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
from flask import Flask, request, abort
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


def init_db():
    """Initialize the SQLite database and create tables if they don't exist."""
    app.logger.debug("Initializing database...")
    
    db_path = Path(args.db_name)
    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()
    
    # Create table for webhook events
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS webhook_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            event_type TEXT,
            payload TEXT,
            signature TEXT
        )
    ''')
    
    conn.commit()
    conn.close()
    app.logger.debug(f"Database initialized at {db_path.absolute()}")


app = Flask(__name__)


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
        
        # Store webhook data in database with more detailed logging
        try:
            app.logger.debug(f"Attempting to connect to database: {args.db_name}")
            conn = sqlite3.connect(args.db_name)
            cursor = conn.cursor()
            
            # Log the data we're about to insert
            app.logger.debug(f"Preparing to insert - Event Type: {event_type}")
            app.logger.debug(f"Signature: {signature_header}")
            
            insert_query = '''
                INSERT INTO webhook_events (event_type, payload, signature)
                VALUES (?, ?, ?)
            '''
            values = (
                event_type,
                json.dumps(request.json),
                signature_header
            )
            
            app.logger.debug("Executing insert query...")
            cursor.execute(insert_query, values)
            
            app.logger.debug("Committing transaction...")
            conn.commit()
            
            # Verify the insert worked
            cursor.execute("SELECT COUNT(*) FROM webhook_events")
            count = cursor.fetchone()[0]
            app.logger.debug(f"Total records in database: {count}")
            
            app.logger.debug(f"Successfully stored webhook data in database: {args.db_name}")
        except Exception as e:
            app.logger.error(f"Failed to store webhook data: {str(e)}")
            app.logger.error(f"Error type: {type(e)}")
            # Re-raise the exception to see the full traceback in the logs
            raise
        finally:
            if 'conn' in locals():
                conn.close()
                app.logger.debug("Database connection closed")
            
        return ('status', args.status_code)


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

    # Initialize the database before starting the app
    init_db()
    
    app.config['DEBUG'] = True
    app.run(host='localhost', port=8000)
