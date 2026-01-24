from flask import Flask, request, jsonify, render_template, redirect, session
import json
from datetime import datetime
import sqlite3
import os
from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import HtmlFormatter
import re
import argparse
from functools import wraps

app = Flask(__name__)
app.secret_key = os.urandom(24)  # Required for session

# Database setup
DB_PATH = 'audit.db'

# Initialize empty set for valid tokens
VALID_TOKENS = set()

# Parse command line arguments
parser = argparse.ArgumentParser(description='HEC Event Collector')
parser.add_argument('--token', help='Authentication token for the collector')
parser.add_argument('--username', help='Username for web interface authentication')
parser.add_argument('--password', help='Password for web interface authentication')
args = parser.parse_args()

# Add token if provided
if args.token:
    VALID_TOKENS.add(args.token)
    print(f"Added token to valid tokens: {args.token}")

# Store web interface credentials
WEB_USERNAME = args.username
WEB_PASSWORD = args.password

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('authenticated'):
            return redirect('/login')
        return f(*args, **kwargs)
    return decorated_function

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if username == WEB_USERNAME and password == WEB_PASSWORD:
            session['authenticated'] = True
            return redirect('/auditdb')
        else:
            return render_template('login.html', error='Invalid credentials')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('authenticated', None)
    return redirect('/login')

def format_json(data, search_terms=None):
    """Format JSON data with syntax highlighting and search term highlighting"""
    json_str = json.dumps(data, indent=2)
    
    # First, get the syntax highlighted HTML
    highlighted = highlight(json_str, JsonLexer(), HtmlFormatter())
    
    # Then, if we have search terms, highlight them
    if search_terms:
        # Split search terms and remove empty strings
        terms = [term.strip() for term in search_terms.split() if term.strip()]
        print(f"Highlighting search terms: {terms}")
        
        for term in terms:
            # Create a case-insensitive pattern that matches whole words
            pattern = re.compile(r'\b(' + re.escape(term) + r')\b', re.IGNORECASE)
            # Replace matches with highlighted version
            highlighted = pattern.sub(r'<span class="search-highlight">\1</span>', highlighted)
    
    return highlighted

def init_db():
    """Initialize the database with required tables"""
    print("\nInitializing database...")
    
    # Check if database exists
    db_exists = os.path.exists(DB_PATH)
    if db_exists:
        print(f"Using existing database: {DB_PATH}")
    else:
        print(f"Creating new database: {DB_PATH}")
    
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    try:
        # First, handle the events table
        print("Handling events table...")
        c.execute("DROP TABLE IF EXISTS events")
        
        # Create the main events table first
        print("Creating events table...")
        c.execute('''
            CREATE TABLE IF NOT EXISTS events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                token TEXT,
                received_at TIMESTAMP,
                event_data JSON,
                source_ip TEXT
            )
        ''')
        
        # Now reset autoincrement - sqlite_sequence will exist
        print("Resetting autoincrement counters")
        c.execute("DELETE FROM sqlite_sequence")
        
        # Then handle FTS tables
        print("Handling FTS tables...")
        for table in ['events_fts', 'events_fts_data', 'events_fts_idx', 'events_fts_docsize', 'events_fts_config']:
            c.execute(f"DROP TABLE IF EXISTS {table}")
        
        # Create the FTS5 virtual table
        print("Creating FTS5 virtual table...")
        c.execute('''
            CREATE VIRTUAL TABLE IF NOT EXISTS events_fts 
            USING fts5(
                token,
                event_data,
                content='events',
                content_rowid='id'
            )
        ''')
        
        # Create triggers
        print("Creating triggers...")
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
        
        # Check if we have any events
        c.execute("SELECT COUNT(*) FROM events")
        count = c.fetchone()[0]
        print(f"Current event count: {count}")
        
        if count > 0:
            # Show sample events
            c.execute("SELECT id, token, received_at, event_data FROM events LIMIT 3")
            sample_events = c.fetchall()
            print("\nSample events in database:")
            for event in sample_events:
                print(f"ID: {event[0]}, Token: {event[1]}, Time: {event[2]}")
                print(f"Data: {event[3][:200]}...")  # Print first 200 chars of event data
        
        conn.commit()
        print("Database initialization completed successfully")
    except Exception as e:
        print(f"Error initializing database: {str(e)}")
        raise
    finally:
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
        # Log the detailed error on the server, but do not expose it to the client
        print(f"Error storing event in database: {e}")
        return False, "Database error"
    finally:
        conn.close()

def search_events_db(query):
    """Search events in the database"""
    print(f"\nSearching for: {query}")
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    
    try:
        # First check if the table exists
        c.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='events'")
        if not c.fetchone():
            print("Events table does not exist!")
            return []
            
        # Check if we have any events
        c.execute("SELECT COUNT(*) FROM events")
        count = c.fetchone()[0]
        print(f"Total events in database: {count}")
        
        # For exact string matches (like Base64), use LIKE instead of FTS
        if any(char in query for char in '/+='): # Common Base64 characters
            print("Detected Base64-like string, using LIKE query")
            search_query = '''
                SELECT e.id, e.token, e.received_at, e.event_data, e.source_ip
                FROM events e
                WHERE e.event_data LIKE ?
                   OR e.token LIKE ?
                ORDER BY e.received_at DESC
                LIMIT 100
            '''
            search_pattern = f'%{query}%'
            c.execute(search_query, (search_pattern, search_pattern))
        else:
            # Regular FTS search for non-Base64 queries
            safe_query = ' '.join(query.split())  # Normalize spaces
            print(f"Using FTS search with query: {safe_query}")
            search_query = '''
                SELECT e.id, e.token, e.received_at, e.event_data, e.source_ip
                FROM events e
                JOIN events_fts fts ON e.id = fts.rowid
                WHERE events_fts MATCH ?
                ORDER BY e.received_at DESC
                LIMIT 100
            '''
            c.execute(search_query, (safe_query,))
        
        results = []
        for row in c.fetchall():
            results.append({
                'id': row[0],
                'token': row[1],
                'received_at': row[2],
                'event_data': json.loads(row[3]),
                'source_ip': row[4]
            })
        
        print(f"Found {len(results)} results")
        return results
    except Exception as e:
        print(f"Error searching events: {str(e)}")
        raise
    finally:
        conn.close()

@app.route('/')
def index():
    """
    Redirect root to auditdb
    """
    return redirect('/auditdb')

@app.route('/auditdb')
@login_required
def search_page():
    """
    Web interface for searching events
    """
    query = request.args.get('q', '')
    results = None
    error = None
    
    print(f"\nSearch page accessed with query: {query}")
    
    # Verify database connection
    try:
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute("SELECT COUNT(*) FROM events")
        count = c.fetchone()[0]
        print(f"Database contains {count} events")
        conn.close()
    except Exception as e:
        print(f"Database verification error: {str(e)}")
        error = f"Database error: {str(e)}"
        return render_template('search.html',
            query=query,
            results=None,
            error=error,
            format_json=lambda data: format_json(data, query)
        )
    
    if query:
        try:
            results = search_events_db(query)
            print(f"Search returned {len(results) if results else 0} results")
        except Exception as e:
            error = f"Error searching events: {str(e)}"
            print(f"Search error: {error}")
    else:
        # If no query, show all events
        try:
            conn = sqlite3.connect(DB_PATH)
            c = conn.cursor()
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
            print(f"Showing all events: {len(results)} found")
            conn.close()
        except Exception as e:
            error = f"Error fetching events: {str(e)}"
            print(f"Error: {error}")
    
    # Create a formatter function that includes the search query
    def format_with_query(data):
        return format_json(data, query)
    
    return render_template('search.html',
        query=query,
        results=results,
        error=error,
        format_json=format_with_query
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
    
    # Validate the token against configured valid tokens
    if VALID_TOKENS and token not in VALID_TOKENS:
        print(f"Error: Invalid token '{token}' - not in configured valid tokens")
        return {"text": "Invalid token", "code": 3}, 401
    
    # Get source IP with priority: X-Forwarded-For > X-Real-IP > remote_addr
    source_ip = request.headers.get('X-Forwarded-For', '').split(',')[0].strip()
    if not source_ip:
        source_ip = request.headers.get('X-Real-IP', '')
    if not source_ip:
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
                        # Log the detailed error internally
                        print(f"Error storing event: {result}")
                        # Return a generic error message to the client
                        return {"text": "Failed to store event", "code": 8}, 500
                
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
@login_required
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
    
    print("Press Ctrl+C to stop")
    print("-" * 80)
    debug_mode = os.getenv('FLASK_DEBUG', '0') == '1'
    app.run(debug=debug_mode, host='0.0.0.0', port=8001)
