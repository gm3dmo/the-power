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
from flask import Flask, request, abort, g, redirect, render_template, url_for, Response
import hashlib
import hmac
from werkzeug.exceptions import HTTPException  # Add this import
import sqlite3
from pathlib import Path
import queue

# Create a global event queue for SSE notifications
event_queue = queue.Queue()

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

# Add configuration class
class Config:
    def __init__(self):
        # Get values from environment variables first, fall back to defaults
        self.hook_secret = os.environ.get('WEBHOOK_SECRET')
        self.status_code = int(os.environ.get('STATUS_CODE', '200'))
        self.db_name = os.environ.get('DB_NAME', 'hooks.db')

# Create config instance
config = Config()

# Then define database functions
def get_db():
    conn = sqlite3.connect(config.db_name)
    return conn

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
    
    # Ensure table includes an "action_type" column
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS webhook_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now', 'localtime')),
            event_type TEXT,
            payload TEXT,
            signature TEXT,
            headers TEXT,
            action_type TEXT
        )
    ''')
    
    # If the table already existed before "action_type" was introduced,
    # optionally try an ALTER TABLE here:
    try:
        cursor.execute('ALTER TABLE webhook_events ADD COLUMN action_type TEXT')
    except sqlite3.OperationalError:
        pass  # Column already exists or cannot be added because it already exists

    db.commit()
    app.logger.debug(f"Database initialized at {config.db_name}")


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
        
        if signature_header and config.hook_secret:
            verify_signature(request.data, config.hook_secret, signature_header)
        else:
            app.logger.debug("Skipping signature verification - no signature header or secret provided")
        
        # Format headers for storage
        headers_dict = dict(request.headers)
        headers_formatted = json.dumps(headers_dict, indent=2)

        # Extract action from the JSON, if available
        action_value = request.json.get('action')
        
        # Store webhook data in database
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute('''
                INSERT INTO webhook_events (event_type, payload, signature, headers, action_type)
                VALUES (?, ?, ?, ?, ?)
            ''', (
                event_type,
                json.dumps(request.json),
                signature_header,
                headers_formatted,
                action_value
            ))
            db.commit()
            app.logger.debug(f"Webhook data stored in database: {config.db_name}")
            
            # Ensure the event queue message is sent
            try:
                event_queue.put_nowait("refresh")
                app.logger.debug("Refresh message sent to event queue")
            except queue.Full:
                app.logger.warning("Event queue is full, clearing and resending")
                while not event_queue.empty():
                    event_queue.get_nowait()
                event_queue.put_nowait("refresh")
            
            return ('', config.status_code)
        except Exception as e:
            app.logger.error(f"Failed to store webhook data: {str(e)}")
            raise


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


@app.route('/hookdb')
def hookdb():
    search = request.args.get('search', default='')
    record_id = request.args.get('id', type=int)

    try:
        db = get_db()
        cursor = db.cursor()

        # First, update action_type from stored payloads
        cursor.execute('''
            UPDATE webhook_events 
            SET action_type = json_extract(payload, '$.action')
            WHERE action_type IS NULL
            AND json_valid(payload)
            AND json_extract(payload, '$.action') IS NOT NULL
        ''')
        db.commit()

        # Then proceed with the existing query logic
        if search:
            cursor.execute('''
                SELECT * FROM webhook_events
                WHERE event_type LIKE ?
                ORDER BY id DESC
            ''', (f'%{search}%',))
        else:
            cursor.execute('''
                SELECT * FROM webhook_events
                ORDER BY id DESC
            ''')

        table_rows = cursor.fetchall()

        selected_record = None
        headers_data = None
        formatted_headers = ''
        formatted_payload = ''

        if record_id:
            # Query the single record
            cursor.execute('SELECT * FROM webhook_events WHERE id=?', (record_id,))
            selected_record = cursor.fetchone()

            if selected_record:
                # For debugging, print the entire row:
                print("DEBUG - selected_record:", selected_record)

                # Typically:
                #  selected_record[0]: id
                #  selected_record[1]: timestamp
                #  selected_record[2]: event_type
                #  selected_record[3]: payload
                #  selected_record[4]: signature
                #  selected_record[5]: headers
                #  selected_record[6]: action_type  (depends on your DB schema)

                raw_headers = selected_record[5]  # verify this matches your schema
                raw_payload = selected_record[3]

                # Print the raw headers for debugging
                print("DEBUG - raw_headers value:", raw_headers)

                # Attempt to parse headers as JSON
                try:
                    headers_data = json.loads(raw_headers)
                    # For fallback or display in <pre>
                    formatted_headers = json.dumps(headers_data, indent=2)
                except (json.JSONDecodeError, TypeError) as e:
                    print("DEBUG - JSON decode error for headers:", e)
                    headers_data = None
                    formatted_headers = raw_headers or "No headers found"

                # Attempt to parse payload as JSON
                try:
                    payload_data = json.loads(raw_payload)
                    formatted_payload = json.dumps(payload_data, indent=2)
                except (json.JSONDecodeError, TypeError) as e:
                    print("DEBUG - JSON decode error for payload:", e)
                    formatted_payload = raw_payload or "No payload found"

        return render_template(
            'hookdb.html',
            search=search,
            table_records=table_rows,
            selected_record=selected_record,
            headers_data=headers_data,
            formatted_headers=formatted_headers,
            formatted_payload=formatted_payload
        )
    except Exception as e:
        return f"Error loading events: {e}", 500


@app.route('/clear', methods=['POST'])
def clear_events():
    try:
        db = get_db()
        cursor = db.cursor()
        cursor.execute('DELETE FROM webhook_events')
        db.commit()
        return {'status': 'success'}, 200
    except Exception as e:
        return {'status': 'error', 'message': str(e)}, 500


@app.route('/stream')
def stream():
    def event_stream():
        while True:
            try:
                # Add a timeout to prevent blocking forever
                message = event_queue.get(timeout=20)
                app.logger.debug(f"Sending SSE message: {message}")
                yield f"data: {message}\n\n"
            except queue.Empty:
                # Send a keep-alive comment to prevent connection timeout
                yield ": keep-alive\n\n"
            except Exception as e:
                app.logger.error(f"Error in event stream: {e}")
                break
    
    return Response(
        event_stream(),
        mimetype="text/event-stream",
        headers={
            'Cache-Control': 'no-cache',
            'Connection': 'keep-alive',
            'X-Accel-Buffering': 'no'  # Disable proxy buffering
        }
    )


def clear_event_queue():
    """Clear all messages from the event queue."""
    while not event_queue.empty():
        try:
            event_queue.get_nowait()
        except queue.Empty:
            break


if __name__ == '__main__':
    # Keep command line argument support for direct Python execution
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
    
    # Override config with command line arguments
    config.hook_secret = args.hook_secret
    config.status_code = args.status_code
    config.db_name = args.db_name
    
    # Clear the event queue on startup
    clear_event_queue()
    app.logger.debug("Event queue cleared on startup")
    
    # Create app context before initializing database
    with app.app_context():
        init_db()
    
    app.config['DEBUG'] = True
    app.run(host='localhost', port=8000)
