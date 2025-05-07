from flask import Flask, request, jsonify, render_template
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
DB_PATH = 'hec_events.db'

# Valid tokens for development
VALID_TOKENS = {
    'test-token-123',  # Test token from test-sender.py
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
def receive_hec_event():
    """
    Endpoint to receive HEC events and store them
    """
    print("\nReceived request:")
    print(f"Content-Type: {request.headers.get('Content-Type')}")
    print(f"Authorization: {request.headers.get('Authorization')}")
    print(f"Request data: {request.get_data()}")
    
    if not request.is_json:
        print("Error: Content-Type is not application/json")
        return jsonify({"error": "Content-Type must be application/json"}), 400
    
    # Get the authorization header
    auth_header = request.headers.get('Authorization', '')
    if not auth_header.startswith('Splunk '):
        print("Error: Invalid authorization header format")
        return jsonify({"error": "Invalid authorization header"}), 401
    
    # Extract the token
    token = auth_header.split(' ')[1]
    
    # Validate token
    if token not in VALID_TOKENS:
        print(f"Error: Invalid token: {token}")
        return jsonify({"error": "Invalid token"}), 401
    
    # Get the event data
    try:
        event_data = request.get_json()
        if not event_data:
            print("Error: Empty JSON data")
            return jsonify({"error": "Empty JSON data"}), 400
    except Exception as e:
        print(f"Error parsing JSON: {str(e)}")
        return jsonify({"error": f"Invalid JSON data: {str(e)}"}), 400
    
    # Store the event
    success, result = store_event(token, event_data, request.remote_addr)
    
    if success:
        print(f"\nStored event {result} with token: {token}")
        print("\nEvent data:")
        print(json.dumps(event_data, indent=2))
        print(f"\nReceived at: {datetime.now().isoformat()}")
        print("-" * 80)
        return jsonify({"text": "Success", "code": 0})
    else:
        print(f"Error storing event: {result}")
        return jsonify({"error": f"Failed to store event: {result}"}), 500

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

@app.route('/health', methods=['GET'])
def health_check():
    """
    Health check endpoint
    """
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    # Initialize the database
    init_db()
    
    print("Starting HEC event receiver on http://localhost:8002")
    print("Send events to: http://localhost:8002/services/collector")
    print("Search events at: http://localhost:8002/")
    print("API search at: http://localhost:8002/search?q=your_search_term")
    print("Press Ctrl+C to stop")
    print("-" * 80)
    app.run(debug=True, host='0.0.0.0', port=8002)
