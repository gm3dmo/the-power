from flask import Flask, request, jsonify, render_template, redirect
import json
from datetime import datetime
import sqlite3
import os
from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import HtmlFormatter
import re

app = Flask(__name__)

# Database setup
DB_PATH = 'auditdb'

# Valid tokens for development
VALID_TOKENS = {
    'test-token-123',  # Test token from test-sender.py
    'token-123',       # GitHub's token
}

def format_json(data, search_terms=None):
    """Format JSON data with syntax highlighting and search term highlighting"""
    json_str = json.dumps(data, indent=2)
    
    # First, get the syntax highlighted HTML
    highlighted = highlight(json_str, JsonLexer(), HtmlFormatter())
    
    # Then, if we have search terms, highlight them
    if search_terms:
        terms = [term.strip() for term in search_terms.split() if term.strip()]
        for term in terms:
            # Create a case-insensitive pattern
            pattern = re.compile(f'({re.escape(term)})', re.IGNORECASE)
            # Replace matches with highlighted version
            highlighted = pattern.sub(r'<span class="search-highlight">\1</span>', highlighted)
    
    return highlighted

def init_db():
    """Initialize the database with required tables"""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    # Create the main events table
    c.execute('''
        CREATE TABLE IF NOT EXISTS events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            token TEXT,
            received_at TIMESTAMP,
            event_data JSON,
            source_ip TEXT
        )
    ''')
    
    # Create the FTS5 virtual table for full-text search
    c.execute('''
        CREATE VIRTUAL TABLE IF NOT EXISTS events_fts 
        USING fts5(
            token,
            event_data,
            content='events',
            content_rowid='id'
        )
    ''')
    
    # Create triggers to maintain the FTS index
    c.execute('''
        CREATE TRIGGER IF NOT EXISTS events_ai AFTER INSERT ON events BEGIN
            INSERT INTO events_fts(rowid, token, event_data)
            VALUES (new.id, new.token, new.event_data);
        END
    ''')
    
    c.execute('''
        CREATE TRIGGER IF NOT EXISTS events_ad AFTER DELETE ON events BEGIN
            INSERT INTO events_fts(events_fts, rowid, token, event_data)
            VALUES('delete', old.id, old.token, old.event_data);
        END
    ''')
    
    c.execute('''
        CREATE TRIGGER IF NOT EXISTS events_au AFTER UPDATE ON events BEGIN
            INSERT INTO events_fts(events_fts, rowid, token, event_data)
            VALUES('delete', old.id, old.token, old.event_data);
            INSERT INTO events_fts(rowid, token, event_data)
            VALUES (new.id, new.token, new.event_data);
        END
    ''')
    
    conn.commit()
    conn.close()

def store_event(token, event_data, source_ip):
    """Store an event in the database"""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    try:
        c.execute('''
            INSERT INTO events (token, received_at, event_data, source_ip)
            VALUES (?, ?, ?, ?)
        ''', (token, datetime.now().isoformat(), json.dumps(event_data), source_ip))
        conn.commit()
        return True, c.lastrowid
    except Exception as e:
        return False, str(e)
    finally:
        conn.close()

def search_events_db(query):
    """Search events in the database"""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    try:
        c.execute('''
            SELECT e.id, e.token, e.received_at, e.event_data, e.source_ip
            FROM events e
            JOIN events_fts fts ON e.id = fts.rowid
            WHERE events_fts MATCH ?
            ORDER BY e.received_at DESC
            LIMIT 100
        ''', (query,))
        
        results = []
        for row in c.fetchall():
            results.append({
                'id': row[0],
                'token': row[1],
                'received_at': row[2],
                'event_data': json.loads(row[3]),
                'source_ip': row[4]
            })
        
        return results
    finally:
        conn.close()

@app.route('/')
def index():
    """
    Redirect root to auditdb
    """
    return redirect('/auditdb')

@app.route('/auditdb')
def search_page():
    """
    Web interface for searching events
    """
    query = request.args.get('q', '')
    results = None
    error = None
    
    if query:
        try:
            results = search_events_db(query)
        except Exception as e:
            error = f"Error searching events: {str(e)}"
    
    return render_template('search.html',
        query=query,
        results=results,
        error=error,
        format_json=lambda data: format_json(data, query)
    )

@app.route('/services/collector', methods=['POST'])
@app.route('/services/collector/event', methods=['POST'])
def receive_hec_event():
    """
    Endpoint to receive HEC events and store them
    """
    print("\nReceived request:")
    print(f"Content-Type: {request.headers.get('Content-Type')}")
    print(f"Authorization: {request.headers.get('Authorization')}")
    print(f"Request data: {request.get_data()}")
    
    # Get the authorization header
    auth_header = request.headers.get('Authorization', '')
    if not auth_header.startswith('Splunk '):
        print("Error: No Splunk token in Authorization header")
        return {"text": "Token is required", "code": 2}, 401
    
    # Extract the token
    token = auth_header.split(' ')[1]
    print(f"Extracted token: {token}")
    
    # Get source IP
    if request.headers.get('X-Real-IP'):
        source_ip = request.headers.get('X-Real-IP')
    else:
        source_ip = request.remote_addr
    print(f"Source IP: {source_ip}")
    
    # Handle the request data
    content_type = request.headers.get('Content-Type', '')
    print(f"Content-Type: {content_type}")
    
    if content_type == "application/json":
        if request.data == b'':
            print("Empty request - returning success")
            return {"text": "Success", "code": 0}
        else:
            try:
                # Split the request data into individual JSON objects
                data_str = request.get_data().decode('utf-8')
                json_objects = []
                current_pos = 0
                
                while current_pos < len(data_str):
                    try:
                        # Find the next complete JSON object
                        obj_end = data_str.find('}{', current_pos)
                        if obj_end == -1:
                            # Last object
                            json_str = data_str[current_pos:]
                        else:
                            json_str = data_str[current_pos:obj_end + 1]
                        
                        # Parse the JSON object
                        event_data = json.loads(json_str)
                        json_objects.append(event_data)
                        
                        if obj_end == -1:
                            break
                        current_pos = obj_end + 1
                    except json.JSONDecodeError as e:
                        print(f"Error parsing JSON object at position {current_pos}: {str(e)}")
                        return {"text": "Invalid JSON data", "code": 6}, 400
                
                # Store each event
                for event_data in json_objects:
                    success, result = store_event(token, event_data, source_ip)
                    if not success:
                        print(f"Error storing event: {result}")
                        return {"text": f"Failed to store event: {result}", "code": 8}, 500
                
                print(f"\nStored {len(json_objects)} events with token: {token}")
                print(f"\nReceived at: {datetime.now().isoformat()}")
                print("-" * 80)
                return {"text": "Success", "code": 0}
                
            except Exception as e:
                print(f"Error processing request: {str(e)}")
                return {"text": "Invalid JSON data", "code": 6}, 400
    else:
        print(f"Invalid Content-Type: {content_type}")
        return {"text": "Content-Type must be application/json", "code": 5}, 400

@app.route('/search', methods=['GET'])
def search_events():
    """
    Search events using full-text search (API endpoint)
    """
    query = request.args.get('q', '')
    if not query:
        return jsonify({"error": "No search query provided"}), 400
    
    try:
        results = search_events_db(query)
        return jsonify({"results": results})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/auditdb/events', methods=['GET'])
def list_events():
    """
    List all stored events
    """
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    try:
        c.execute('''
            SELECT id, token, received_at, event_data, source_ip
            FROM events
            ORDER BY received_at DESC
            LIMIT 100
        ''')
        
        results = []
        for row in c.fetchall():
            results.append({
                'id': row[0],
                'token': row[1],
                'received_at': row[2],
                'event_data': json.loads(row[3]),
                'source_ip': row[4]
            })
        
        return render_template('search.html',
            query='',
            results=results,
            error=None,
            format_json=lambda data: format_json(data)
        )
    finally:
        conn.close()

if __name__ == '__main__':
    # Initialize the database
    init_db()
    
    print("Starting HEC event receiver on http://localhost:8000")
    print("Send events to: http://localhost:8000/services/collector")
    print("Search events at: http://localhost:8000/auditdb")
    print("List all events at: http://localhost:8000/auditdb/events")
    print("API search at: http://localhost:8000/search?q=your_search_term")
    print("Press Ctrl+C to stop")
    print("-" * 80)
    app.run(debug=True, host='0.0.0.0', port=8000)
