# Send GitHub Audit Log Stream to Splunk HTTP Event Collector

Use this application to receive GitHub audit log stream events without a Splunk installation. See the GitHub guidance on [setting up streaming to Splunk](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise#setting-up-streaming-to-splunk) to configure the GitHub side.

## Setup

### Clone the power:

```bash
git clone https://github.com/gm3dmo/the-power
```

### Create a virtual environment:

```bash
cd the-power/http-event-collector
python -m venv .venv
```

Install the required dependencies:

```bash
pip install -r requirements.txt
```

### Proxy Configuration
This is my `/etc/caddy/Caddfile` which is just enough proxy for me:

```bash
{
 debug
 servers {
 protocols h2
 protocols h1
 }
}

hooky.seyosh.org {                                                                                                                    header Custom-Header "the-power-hooklistener"
    root * /usr/share/caddy
    file_server                                                                                                                           @http2only {
    }
    reverse_proxy 127.0.0.1:8000
}                                                                                                                                 audit.seyosh.org {
    header Custom-Header "the-power-http-event-collector"
    root * /usr/share/caddy
    file_server
        @http2only {
    }                                                                                                                                 reverse_proxy 127.0.0.1:8001
}
```
Make sure your proxying web server is running.

## Running the Application

Start the *http-event-collector* application:

```bash
python app.py --username admin --password mysecret --token mytoken
```

The application will run on `http://localhost:8001`

Use username and password in the web UI where you are proxying onto port 8001

The token is the "token" field in your splunk audit log stream in GitHub.

## API Endpoints

### Receive and Forward Event
- **URL**: `/receive-event`
- **Method**: `POST`
- **Content-Type**: `application/json`
- **Request Body**: JSON object containing event data
- **Example**:
```bash
curl -X POST http://localhost:8002/receive-event \
  -H "Content-Type: application/json" \
  -d '{"message": "Test event", "severity": "info"}'
```

The application will:
- Add metadata to the event (received_at timestamp and source IP)
- Forward the event to Splunk
- Return a response indicating success or failure

### Health Check
- **URL**: `/health`
- **Method**: `GET`
- **Response**: JSON object indicating application health status

## Security Notes

1. In production, set `verify=True` in the `forward_to_splunk` function and ensure proper SSL certificates are in place.
2. Store your HEC token securely and never commit it to version control.
3. Consider implementing additional authentication for the API endpoints in production.
4. Consider implementing rate limiting to prevent abuse.

## Error Handling

The application includes basic error handling for:
- Invalid JSON payloads
- Failed Splunk HEC connections
- Missing configuration

All errors are returned with appropriate HTTP status codes and error messages. 
