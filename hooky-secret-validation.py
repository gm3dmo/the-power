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
from flask import Flask, request, abort, g, redirect, render_template
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


@app.route('/hookdb')
def hookdb():
    try:
        # Get 'search' param for filtering
        search = request.args.get('search', default='')

        # Get 'id' param for selecting a single record's details
        record_id = request.args.get('id', type=int)

        db = get_db()
        cursor = db.cursor()

        # Build our SELECT query. If 'search' is set, filter by event_type
        if search:
            cursor.execute('''
                SELECT id, timestamp, event_type, payload, signature, headers
                FROM webhook_events
                WHERE event_type LIKE ?
                ORDER BY timestamp DESC
            ''', (f'%{search}%',))
        else:
            cursor.execute('''
                SELECT id, timestamp, event_type, payload, signature, headers
                FROM webhook_events
                ORDER BY timestamp DESC
            ''')

        raw_records = cursor.fetchall()

        # Build a new list that includes an "action" field if found
        table_rows = []
        for record in raw_records:
            (rec_id, rec_timestamp, rec_event_type, rec_payload, rec_signature, rec_headers) = record
            action_val = ''

            # Attempt to parse JSON payload, and extract 'action' if present
            if rec_payload:
                try:
                    rec_payload_json = json.loads(rec_payload)
                    if 'action' in rec_payload_json:
                        action_val = rec_payload_json['action']
                except json.JSONDecodeError:
                    pass

            # We'll store each row as a tuple with 7 items:
            # 0=id, 1=timestamp, 2=event_type, 3=payload, 4=signature, 5=headers, 6=extracted action
            table_rows.append((
                rec_id, 
                rec_timestamp,
                rec_event_type,
                rec_payload,
                rec_signature,
                rec_headers,
                action_val
            ))

        # Prepare details for a selected record if an id was specified
        selected_record = None
        formatted_payload = ''
        formatted_headers = ''
        if record_id:
            cursor.execute('SELECT * FROM webhook_events WHERE id = ?', (record_id,))
            selected_record = cursor.fetchone()
            if selected_record:
                try:
                    payload_json = json.loads(selected_record[3])
                    formatted_payload = json.dumps(payload_json, indent=2)
                except (json.JSONDecodeError, TypeError):
                    formatted_payload = selected_record[3] or ''
                try:
                    headers_json = json.loads(selected_record[5])
                    formatted_headers = json.dumps(headers_json, indent=2)
                except (json.JSONDecodeError, TypeError):
                    formatted_headers = selected_record[5] or ''

        return render_template(
            'hookdb.html',
            search=search,
            table_records=table_rows,
            selected_record=selected_record,
            formatted_payload=formatted_payload,
            formatted_headers=formatted_headers
        )

    except Exception as e:
        app.logger.error(f"Failed to load webhook events: {str(e)}")
        return f"Failed to load webhook events: {str(e)}", 500


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
