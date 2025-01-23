"""
A simple Flask app that will act as a endpoint for a hook.

Create a venv:

    python -m venv hooktest
    source hooktest/bin/activate

    python hooky.py

"""


import os
import argparse
import sys
import json
import string
import time
from flask import Flask, request, abort, g
import hashlib
import hmac
from werkzeug.exceptions import HTTPException  # Add this import
import sqlite3
from pathlib import Path


def verify_signature(payload_body, secret_token, signature_header):
    """
    https://docs.github.com/en/webhooks/using-webhooks/validating-webhook-deliveries

    Verify that the payload was sent from GitHub by validating SHA256.

    Raise and return 403 if not authorized.

    Args:
        payload_body: original request body to verify (request.body())
        secret_token: GitHub app webhook token (WEBHOOK_SECRET)
        signature_header: header received from GitHub (x-hub-signature-256)
    """
    if not signature_header:
        abort(403, description="x-hub-signature-256 header is missing!")
    hash_object = hmac.new(secret_token.encode('utf-8'), msg=payload_body, digestmod=hashlib.sha256)
    expected_signature = "sha256=" + hash_object.hexdigest()
    if not hmac.compare_digest(expected_signature, signature_header):
        abort(403, description="Request signature didn't match signature on record")
    else:
        app.logger.debug("-" * 21)
        app.logger.debug("the webhook signature matches")
        app.logger.debug("-" * 21)


# Create Flask app first
app = Flask(__name__)

# Then define database functions
def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(args.db_name)
        g.db.row_factory = sqlite3.Row
    return g.db

@app.teardown_appcontext
def close_db(error):
    db = g.pop('db', None)
    if db is not None:
        db.close()


def init_db():
    """Initialize the SQLite database and create tables if they don't exist."""
    app.logger.debug("Initializing database...")
    
    db = get_db()
    cursor = db.cursor()
    
    # Create table for webhook events with headers column
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS webhook_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            event_type TEXT,
            payload TEXT,
            signature TEXT,
            headers TEXT
        )
    ''')
    
    # Check if headers column exists, if not add it
    cursor.execute("PRAGMA table_info(webhook_events)")
    columns = [column[1] for column in cursor.fetchall()]
    if 'headers' not in columns:
        cursor.execute('ALTER TABLE webhook_events ADD COLUMN headers TEXT')
    
    db.commit()
    app.logger.debug(f"Database initialized at {args.db_name}")


@app.route('/webhook', methods=['POST'])
def slurphook():
    if request.method == 'POST':
        app.logger.debug("hook triggered")
        app.logger.debug("-" * 21)
        
        signature_header = request.headers.get('X-Hub-Signature-256')
        event_type = request.headers.get('X-GitHub-Event', 'unknown')
        
        app.logger.debug(f"X-Hub-Signature-256: {signature_header}")
        app.logger.debug("-" * 21)
        app.logger.debug(f"Headers: {request.headers}")
        app.logger.debug("-" * 21)
        app.logger.debug(f"JSON payload:\n\n{json.dumps(request.json, indent=4)}")
        
        if signature_header and args.hook_secret:
            verify_signature(request.data, args.hook_secret, signature_header)
        else:
            app.logger.debug("Skipping signature verification - no signature header or secret provided")
        
        # Format headers for storage
        headers_dict = dict(request.headers)
        headers_formatted = json.dumps(headers_dict, indent=2)
        
        # Store webhook data in database
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute('''
                INSERT INTO webhook_events (event_type, payload, signature, headers)
                VALUES (?, ?, ?, ?)
            ''', (
                event_type,
                json.dumps(request.json),
                signature_header,
                headers_formatted
            ))
            db.commit()
            app.logger.debug(f"Webhook data stored in database: {args.db_name}")
        except Exception as e:
            app.logger.error(f"Failed to store webhook data: {str(e)}")
            raise
            
        return ('status', args.status_code)


@app.route('/hookdb', methods=['GET'])
def view_hooks():
    try:
        page = request.args.get('page', 1, type=int)
        sort_by = request.args.get('sort', 'timestamp')
        sort_dir = request.args.get('dir', 'desc')
        search = request.args.get('search', '')  # Get search parameter
        
        db = get_db()
        cursor = db.cursor()
        
        # Modify queries to include search
        search_condition = "WHERE event_type LIKE ?" if search else ""
        search_param = (f"%{search}%",) if search else ()
        
        cursor.execute(f'SELECT COUNT(*) FROM webhook_events {search_condition}', search_param)
        total_records = cursor.fetchone()[0]
        
        # Get current record for main display using ID instead of offset
        cursor.execute('''
            SELECT timestamp, event_type, payload, signature 
            FROM webhook_events 
            WHERE rowid = ?
        ''', (page,))
        
        hook = cursor.fetchone()
        if not hook:  # If no record found, get the first one
            cursor.execute('''
                SELECT timestamp, event_type, payload, signature 
                FROM webhook_events 
                ORDER BY timestamp DESC
                LIMIT 1
            ''')
            hook = cursor.fetchone()
        
        # Get 8 records for the table with their rowids, including search filter
        cursor.execute(f'''
            SELECT rowid, timestamp, event_type, signature 
            FROM webhook_events 
            {search_condition}
            ORDER BY {sort_by} {sort_dir}
            LIMIT 8
        ''', search_param)
        
        table_records = cursor.fetchall()
        
        # Add search box to HTML
        html = f'''
        <!DOCTYPE html>
        <html>
        <head>
            <title>Webhook Events</title>
            <style>
                body {{
                    font-family: Helvetica, Arial, sans-serif;
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #ffffff;
                    color: #333333;
                }}
                .container {{
                    padding: 20px;
                }}
                h1 {{
                    font-weight: 500;
                    text-align: center;
                    margin-bottom: 30px;
                    color: #000000;
                }}
                .event-info {{
                    margin: 20px 0;
                    padding: 20px;
                    border: 1px solid #e1e1e1;
                    border-radius: 3px;
                }}
                .event-info p {{
                    margin: 10px 0;
                    line-height: 1.5;
                }}
                .nav-buttons {{
                    text-align: center;
                    margin: 20px 0;
                }}
                .nav-button {{
                    display: inline-block;
                    padding: 8px 16px;
                    margin: 0 10px;
                    background-color: #000000;
                    color: white;
                    text-decoration: none;
                    border-radius: 3px;
                }}
                .nav-button:hover {{
                    background-color: #333333;
                }}
                .nav-button.disabled {{
                    background-color: #cccccc;
                    cursor: not-allowed;
                }}
                pre {{
                    background-color: #f8f8f8;
                    padding: 15px;
                    border-radius: 3px;
                    overflow-x: auto;
                    font-family: monospace;
                    max-height: 400px;
                    overflow-y: auto;
                    border: 1px solid #e1e1e1;
                    margin: 10px 0;
                    white-space: pre-wrap;
                    word-wrap: break-word;
                }}
                .page-info {{
                    text-align: center;
                    color: #666666;
                    margin: 20px 0;
                    font-size: 14px;
                }}
                .copy-button {{
                    float: right;
                    padding: 5px 10px;
                    background-color: #000000;
                    color: white;
                    border: none;
                    border-radius: 3px;
                    cursor: pointer;
                    font-family: Helvetica, Arial, sans-serif;
                }}
                .copy-button:hover {{
                    background-color: #333333;
                }}
                .webhook-table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                    font-size: 14px;
                }}
                .webhook-table th, .webhook-table td {{
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #e1e1e1;
                }}
                .webhook-table th {{
                    background-color: #f8f8f8;
                    font-weight: 500;
                    cursor: pointer;
                }}
                .webhook-table th:hover {{
                    background-color: #eaeaea;
                }}
                .webhook-table tr {{
                    cursor: pointer;
                    transition: background-color 0.2s;
                }}
                .webhook-table tr:hover {{
                    background-color: #f8f8f8;
                }}
                .webhook-table tr.selected {{
                    background-color: #f0f0f0;
                }}
                .header-row {{
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 10px;
                }}
                .label {{
                    font-weight: bold;
                    color: #000000;
                }}
                .table-container {{
                    margin: 40px 0;
                    border: 1px solid #e1e1e1;
                    border-radius: 3px;
                    overflow: hidden;
                }}
                .table-title {{
                    font-size: 18px;
                    margin: 20px 0;
                    color: #333;
                }}
                .sort-arrow {{
                    display: inline-block;
                    margin-left: 5px;
                    color: #666;
                }}
                .search-container {{
                    margin: 20px 0;
                    text-align: right;
                }}
                
                .search-box {{
                    padding: 8px;
                    width: 200px;
                    border: 1px solid #e1e1e1;
                    border-radius: 3px;
                    font-family: Helvetica, Arial, sans-serif;
                }}
                
                .search-box:focus {{
                    outline: none;
                    border-color: #000000;
                }}
                
                .search-label {{
                    margin-right: 10px;
                    color: #666666;
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Webhook Events</h1>
                <div class="page-info">Event {page} of {total_records}</div>
        '''
        
        if hook:
            timestamp, event_type, payload, signature = hook
            html += f'''
                <div class="event-info">
                    <p><span class="label">Timestamp:</span> {timestamp}</p>
                    <p><span class="label">Event Type:</span> {event_type}</p>
                    <p><span class="label">Signature:</span> {signature}</p>
                    <div class="header-row">
                        <span class="label">Payload:</span>
                        <button class="copy-button" onclick="copyPayload()">Copy</button>
                    </div>
                    <pre id="payload">{json.dumps(json.loads(payload), indent=2)}</pre>
                </div>
                
                <div class="nav-buttons">
        '''
        
        if page > 1:
            html += f'<a href="/hookdb?page={page-1}&search={search}" class="nav-button">Previous</a>'
        else:
            html += '<span class="nav-button disabled">Previous</span>'
            
        if page < total_records:
            html += f'<a href="/hookdb?page={page+1}&search={search}" class="nav-button">Next</a>'
        else:
            html += '<span class="nav-button disabled">Next</span>'
            
        html += '''
                </div>
                
                <h2 class="table-title">Recent Webhooks</h2>
                <div class="search-container">
                    <label class="search-label">Filter by Event Type:</label>
                    <input type="text" 
                           class="search-box" 
                           placeholder="Search event types... (press Enter to search)"
                           onkeydown="handleSearch(event)"
                           value="''' + search + '''">
                </div>
                <div class="table-container">
                    <table class="webhook-table">
                        <thead>
                            <tr>
        '''
        
        # Modify sort headers to include search parameter
        sort_headers = [
            ('timestamp', 'Timestamp'),
            ('event_type', 'Event Type'),
            ('signature', 'Signature')
        ]
        
        for col, label in sort_headers:
            arrow = '↓' if sort_by == col and sort_dir == 'desc' else '↑' if sort_by == col else ''
            new_dir = 'asc' if sort_by == col and sort_dir == 'desc' else 'desc'
            html += f'''
                <th onclick="window.location.href='/hookdb?page={page}&sort={col}&dir={new_dir}&search={search}'">
                    {label}<span class="sort-arrow">{arrow}</span>
                </th>
            '''
        
        html += '''
                            </tr>
                        </thead>
                        <tbody>
        '''
        
        for rowid, timestamp, event_type, signature in table_records:
            selected = 'selected' if page == rowid else ''
            html += f'''
                <tr class="{selected}" onclick="window.location.href='/hookdb?page={rowid}&search={search}'">
                    <td>{timestamp}</td>
                    <td>{event_type}</td>
                    <td>{signature}</td>
                </tr>
            '''
        
        html += '''
                        </tbody>
                    </table>
                </div>
            </div>
            <script>
                function handleSearch(event) {
                    if (event.key === 'Enter') {
                        const searchValue = event.target.value;
                        const currentUrl = new URL(window.location.href);
                        currentUrl.searchParams.set('search', searchValue);
                        window.location.href = currentUrl.toString();
                    }
                }
                
                function copyPayload() {
                    const payload = document.getElementById('payload').textContent;
                    navigator.clipboard.writeText(payload).then(function() {
                        const button = document.querySelector('.copy-button');
                        button.textContent = 'Copied!';
                        setTimeout(function() {
                            button.textContent = 'Copy';
                        }, 2000);
                    });
                }
                
                document.addEventListener('DOMContentLoaded', function() {
                    const container = document.querySelector('.container');
                    container.style.opacity = '0';
                    container.style.transition = 'opacity 0.5s ease-in';
                    setTimeout(function() {
                        container.style.opacity = '1';
                    }, 100);
                });
            </script>
        </body>
        </html>
        '''
        
        return html
        
    except Exception as e:
        app.logger.error(f"Failed to retrieve webhook data: {str(e)}")
        return f'<h1>Error</h1><p>{str(e)}</p>', 500
    finally:
        if 'conn' in locals():
            conn.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--secret",
        action="store",
        dest="hook_secret",
        default=None,
        help="The secret for the webhook",
    )

    parser.add_argument(
        "--status-code",
        action="store",
        dest="status_code",
        default=200,
        help="The response code the webhook will return",
    )

    parser.add_argument(
        "--db-name",
        action="store",
        dest="db_name",
        default="hooks.db",
        help="The name of the database to store hooks",
    )


    args = parser.parse_args()
    
    # Create app context before initializing database
    with app.app_context():
        init_db()
    
    app.config['DEBUG'] = True
    app.run(host='localhost', port=8000)
