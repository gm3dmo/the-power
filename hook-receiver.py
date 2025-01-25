from flask import Flask, request, render_template, url_for
import sqlite3
import json
import os

app = Flask(
    __name__,
    static_folder='static',        # Serve files from ./static by default
    static_url_path='/static'      # The base URL for static files
)

def get_db():
    # Example: connect to your SQLite database
    conn = sqlite3.connect('webhook_events.db')
    return conn

@app.route('/hookdb')
def hookdb():
    search = request.args.get('search', default='')
    record_id = request.args.get('id', type=int)

    try:
        db = get_db()
        cursor = db.cursor()

        # Filter by event_type if 'search' is provided
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
        formatted_headers = ''
        formatted_payload = ''

        if record_id:
            # Grab the desired record
            cursor.execute('SELECT * FROM webhook_events WHERE id = ?', (record_id,))
            selected_record = cursor.fetchone()
            if selected_record:
                # headers might be in selected_record[3], and payload in selected_record[5], for instance
                raw_headers = selected_record[3]
                raw_payload = selected_record[5]

                # Attempt JSON pretty-print if possible
                try:
                    headers_data = json.loads(raw_headers)
                    formatted_headers = json.dumps(headers_data, indent=2)
                except:
                    formatted_headers = raw_headers or ''

                try:
                    payload_data = json.loads(raw_payload)
                    formatted_payload = json.dumps(payload_data, indent=2)
                except:
                    formatted_payload = raw_payload or ''

        return render_template(
            'hookdb.html',
            search=search,
            table_records=table_rows,
            selected_record=selected_record,
            formatted_payload=formatted_payload,
            formatted_headers=formatted_headers
        )

    except Exception as e:
        return f"Error loading events: {e}", 500

@app.route('/clear', methods=['POST'])
def clear_events():
    # For example, endpoint to clear out events
    try:
        db = get_db()
        cursor = db.cursor()
        cursor.execute('DELETE FROM webhook_events')
        db.commit()
        return {'status': 'success'}, 200
    except Exception as e:
        return {'status': 'error', 'message': str(e)}, 500

if __name__ == '__main__':
    # Run in debug mode for local dev. For production, 
    # use Gunicorn or another production WSGI server.
    app.run(debug=True, host='0.0.0.0', port=5000) 