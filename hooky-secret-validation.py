"""
This is a python Flask app which receives webhooks, stores the hook payload and headers in
a sqlite database. For setup instructions see:

https://github.com/gm3dmo/the-power/blob/main/docs/testing-webhooks.md

"""


import os
import argparse
import sys
import json
import string
import time
from flask import Flask, request, abort, g, redirect, jsonify
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
    
    # Create table only if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS webhook_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now', 'localtime')),
            event_type TEXT,
            payload TEXT,
            signature TEXT,
            headers TEXT
        )
    ''')
    
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


@app.route('/truncate', methods=['POST'])
def truncate_events():
    try:
        db = get_db()
        cursor = db.cursor()
        cursor.execute('DELETE FROM webhook_events')
        db.commit()
        return redirect('/hookdb')
    except Exception as e:
        app.logger.error(f"Failed to truncate events: {str(e)}")
        return f'Error: {str(e)}', 500


@app.route('/clear', methods=['POST'])
def clear_events():
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Drop and recreate the table to ensure a complete reset
        cursor.execute('DROP TABLE IF EXISTS webhook_events')
        cursor.execute('''
            CREATE TABLE webhook_events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now', 'localtime')),
                event_type TEXT,
                payload TEXT,
                signature TEXT,
                headers TEXT
            )
        ''')
        
        db.commit()
        return jsonify({'status': 'success'})
    except Exception as e:
        app.logger.error(f"Failed to clear events: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500


@app.route('/hookdb')
def hookdb():
    try:
        page = request.args.get('page', type=int, default=1)
        search = request.args.get('search', default='')
        sort_by = request.args.get('sort', default='timestamp')
        sort_dir = request.args.get('dir', default='desc')
        
        db = get_db()
        cursor = db.cursor()
        
        # Get total count for pagination
        if search:
            cursor.execute('SELECT COUNT(*) FROM webhook_events WHERE event_type LIKE ?', (f'%{search}%',))
        else:
            cursor.execute('SELECT COUNT(*) FROM webhook_events')
        total_records = cursor.fetchone()[0]
        
        # Calculate previous and next page numbers
        prev_page = max(1, page - 1)
        next_page = min(total_records, page + 1)
        
        # Modify queries to include search
        search_condition = "WHERE event_type LIKE ?" if search else ""
        search_param = (f"%{search}%",) if search else ()
        
        cursor.execute(f'SELECT COUNT(*) FROM webhook_events {search_condition}', search_param)
        total_records = cursor.fetchone()[0]
        
        # Only try to get a record if we have any
        if total_records > 0:
            cursor.execute('''
                SELECT timestamp, event_type, payload, signature, headers 
                FROM webhook_events 
                WHERE rowid = ?
            ''', (page,))
            
            hook = cursor.fetchone()
            if not hook:  # If requested page doesn't exist, get first record
                cursor.execute('''
                    SELECT timestamp, event_type, payload, signature, headers
                    FROM webhook_events 
                    ORDER BY timestamp DESC
                    LIMIT 1
                ''')
                hook = cursor.fetchone()
                if hook:  # If we got a record, update page to match its rowid
                    cursor.execute('SELECT rowid FROM webhook_events ORDER BY timestamp DESC LIMIT 1')
                    page = cursor.fetchone()[0]
        else:
            hook = None
            page = 0
        
        # Get all records for the table with their rowids
        if search:
            cursor.execute('''
                SELECT rowid, timestamp, event_type, payload, signature 
                FROM webhook_events 
                WHERE event_type LIKE ?
                ORDER BY timestamp DESC
            ''', (f'%{search}%',))
        else:
            cursor.execute('''
                SELECT rowid, timestamp, event_type, payload, signature 
                FROM webhook_events 
                ORDER BY timestamp DESC
            ''')
        
        table_records = cursor.fetchall()
        
        # First pass: check if any records have actions
        has_actions = False
        for record in table_records:
            try:
                payload = record[3]  # Make sure payload is at index 3
                if payload is not None:
                    payload_json = json.loads(payload)
                    if 'action' in payload_json:
                        has_actions = True
                        break
            except (json.JSONDecodeError, KeyError, IndexError):
                continue

        # Create event display HTML first
        event_display_html = ''
        if hook:
            timestamp, event_type, payload, signature, headers = hook
            event_display_html = f'''
                <div class="event-info">
                    <p>
                        <span class="info-item"><span class="label">ID:</span> {page} <span class="label">Timestamp:</span> {timestamp}</span>
                        <span class="info-item"><span class="label">Event Type:</span> {event_type}</span>
                        <span class="info-item"><span class="label">Signature:</span> {signature}</span>
                    </p>
                    
                    <div class="header-row">
                        <span class="section-header">Headers:</span>
                        <button class="copy-button" onclick="copyHeaders()">Copy</button>
                    </div>
                    <pre id="headers" class="headers-box">{json.dumps(json.loads(headers) if headers else {}, indent=2)}</pre>
                    
                    <div class="header-row">
                        <span class="section-header">Payload:</span>
                        <button class="copy-button" onclick="copyPayload()">Copy</button>
                    </div>
                    <pre id="payload">{json.dumps(json.loads(payload), indent=2)}</pre>
                </div>
            '''
        
        # Get total count and max rowid
        cursor.execute('SELECT MAX(rowid) FROM webhook_events')
        max_rowid = cursor.fetchone()[0]
        total_records = max_rowid if max_rowid else 0
        
        html = f'''
        <!DOCTYPE html>
        <html>
        <head>
            <title>Webhook Events</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 20px 156px;
                }}
                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                    table-layout: fixed;
                }}
                table th {{
                    padding: 8px 16px;
                    text-align: left;
                    background-color: #f5f5f5;
                    border-bottom: 2px solid #ddd;
                    cursor: pointer;
                    position: sticky;
                    top: 0;
                    z-index: 1;
                    background-color: #fff;
                }}
                table th:nth-child(2), table td:nth-child(2) {{
                    padding-left: 4px;
                }}
                table td {{
                    padding: 8px 16px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    max-width: 0;
                }}
                tr:hover {{
                    background-color: #f5f5f5;
                    cursor: pointer;
                }}
                tr.selected {{
                    background-color: #e0e0e0;
                }}
                .sort-arrow {{
                    margin-left: 5px;
                    color: #999;
                }}
                .nav-buttons {{
                    margin: 20px 0;
                }}
                .nav-buttons button {{
                    padding: 8px 16px;
                    cursor: pointer;
                }}
                .clear-button {{
                    background-color: #ff4444;
                    color: white;
                    border: none;
                    border-radius: 4px;
                }}
                .clear-button:hover {{
                    background-color: #cc0000;
                }}
                .copy-button {{
                    background-color: #006400;  /* Dark green */
                    color: white;
                    border: none;
                    border-radius: 4px;
                    padding: 4px 8px;
                    cursor: pointer;
                }}
                .copy-button:hover {{
                    background-color: #004d00;  /* Darker green on hover */
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
                    cursor: pointer;
                    padding: 10px;
                    text-align: left;
                    border-bottom: 1px solid #e1e1e1;
                    font-weight: bold;
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
                    max-height: 300px;
                    overflow-y: auto;
                    margin: 20px 0;
                    border: 1px solid #e1e1e1;
                    border-radius: 3px;
                }}
                .table-title {{
                    font-size: 18px;
                    margin: 20px 0;
                    color: #333;
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
                
                .headers-box {{
                    background-color: #f8f8f8;
                    padding: 15px;
                    border-radius: 3px;
                    overflow-x: auto;
                    font-family: monospace;
                    max-height: 200px;
                    overflow-y: auto;
                    border: 1px solid #e1e1e1;
                    margin: 10px 0;
                    white-space: pre-wrap;
                    word-wrap: break-word;
                    font-size: 14px;
                }}
                
                .section-header {{
                    margin-top: 20px;
                    margin-bottom: 10px;
                    font-weight: bold;
                    color: #000000;
                }}
                
                pre#payload {{
                    max-height: 300px;
                }}
                
                .danger-zone {{
                    position: fixed;
                    bottom: 20px;
                    right: 20px;
                    text-align: right;
                }}
                
                .danger-button {{
                    font-family: Helvetica, Arial, sans-serif;
                    padding: 10px 20px;
                    background-color: #ff3b30;
                    color: white;
                    border: none;
                    border-radius: 3px;
                    cursor: pointer;
                    transition: background-color 0.2s;
                    font-size: 14px;
                    font-weight: 500;
                }}
                
                .danger-button:hover {{
                    background-color: #dc352b;
                }}
                
                .info-item {{
                    display: inline-block;
                    margin-right: 50px;
                }}
                
                .webhook-table thead {{
                    position: sticky;
                    top: 0;
                    background-color: white;
                    z-index: 1;
                }}
                
                .webhook-table th:first-child,
                .webhook-table td:first-child {{
                    width: 80px;
                    min-width: 80px;
                    max-width: 80px;
                }}
                
                .webhook-table th:nth-child(2),
                .webhook-table td:nth-child(2) {{
                    width: 180px;
                    min-width: 180px;
                    max-width: 180px;
                }}
                
                .webhook-table td {{
                    padding: 10px;
                    border-bottom: 1px solid #e1e1e1;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }}
                
                .event-count {{
                    margin: 20px 0;
                    font-size: 16px;
                    color: #666;
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <h1>The Power Webhook Event Receiver</h1>
                <div class="page-info">Event {page} of {total_records}</div>
                <div class="nav-buttons">
                    <button onclick="window.location.href='/hookdb?page={prev_page}&search={search}'"{' disabled' if page <= 1 else ''}>Previous</button>
                    <button onclick="window.location.href='/hookdb?page={next_page}&search={search}'"{' disabled' if page >= total_records else ''}>Next</button>
                    <button class="clear-button" onclick="clearEvents()">Clear All Events</button>
                </div>
            </div>
            
            <div class="container">
                <h2 class="table-title">Recent Webhooks</h2>
                <div class="search-container">
                    <label class="search-label">Filter by Event Type:</label>
                    <input type="text" 
                           class="search-box" 
                           placeholder="Search event types... (press Enter to search)"
                           onkeydown="handleSearch(event)"
                           value="{search}">
                </div>
                <div class="table-container">
                    <table class="webhook-table">
                        <thead>
                            <tr>
        '''
        
        # Add table headers
        html += '<table><tr>'
        sort_headers = [
            ('rowid', 'Event ID'),
            ('event_type', 'Event Type')
        ]
        if has_actions:
            sort_headers.append(('action', 'Action'))
        sort_headers.extend([
            ('timestamp', 'Timestamp'),
            ('signature', 'Signature')
        ])
        
        for col, label in sort_headers:
            arrow = '↓' if sort_by == col and sort_dir == 'desc' else '↑' if sort_by == col else ''
            new_dir = 'asc' if sort_by == col and sort_dir == 'desc' else 'desc'
            html += f'''
                <th onclick="window.location.href='/hookdb?page={page}&sort={col}&dir={new_dir}&search={search}'">
                    {label}<span class="sort-arrow">{arrow}</span>
                </th>
            '''
        html += '</tr>'
        
        # Add table rows
        for record in table_records:
            try:
                rowid = record[0]
                timestamp = record[1]
                event_type = record[2]
                payload = record[3]
                signature = record[4]
                
                # Extract action from payload
                action = ''
                has_action = False
                try:
                    if payload is not None:
                        payload_json = json.loads(payload)
                        if 'action' in payload_json:
                            action = payload_json['action']
                            has_action = True
                except (json.JSONDecodeError, KeyError):
                    pass
                    
                selected = 'selected' if page == rowid else ''
                html += f'''
                    <tr class="{selected}" onclick="window.location.href='/hookdb?page={rowid}&search={search}'">
                        <td>{rowid}</td>
                        <td>{event_type}</td>'''
                
                if has_actions:
                    html += f'''
                        <td>{action if has_action else ""}</td>'''
                        
                html += f'''
                        <td>{timestamp}</td>
                        <td>{signature}</td>
                    </tr>
                '''
            except IndexError as e:
                app.logger.error(f"Error processing record: {record}, Error: {str(e)}")
                continue
        
        html += '''
                        </thead>
                    </table>
                </div>
                
                <div class="danger-zone">
                    <form id="truncateForm" action="/truncate" method="POST" onsubmit="return confirmTruncate()">
                        <button type="submit" class="danger-button">Clear All Events</button>
                    </form>
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
                
                function copyHeaders() {
                    const headers = document.getElementById('headers').textContent;
                    navigator.clipboard.writeText(headers).then(function() {
                        const button = event.target;
                        button.textContent = 'Copied!';
                        setTimeout(function() {
                            button.textContent = 'Copy';
                        }, 2000);
                    });
                }
                
                function copyPayload() {
                    const payload = document.getElementById('payload').textContent;
                    navigator.clipboard.writeText(payload).then(function() {
                        const button = event.target;
                        button.textContent = 'Copied!';
                        setTimeout(function() {
                            button.textContent = 'Copy';
                        }, 2000);
                    });
                }
                
                function confirmTruncate() {
                    return confirm('Are you sure you want to delete ALL webhook events? This cannot be undone.');
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
