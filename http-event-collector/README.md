# Send GitHub Audit Log Stream to Splunk HTTP Event Collector

Use this application to receive GitHub audit log stream events without a Splunk installation. See the GitHub guidance on [setting up streaming to Splunk](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise#setting-up-streaming-to-splunk) to configure the GitHub side. 

Screencast for this at [Setup HTTP Event Collector for GitHub Audit Log Stream](https://youtu.be/37iLCxu3I90)


## Setup
- Use [tmux](https://en.wikipedia.org/wiki/GNU_Screen) or [screen](https://en.wikipedia.org/wiki/Tmux) for sessions that can survive logout.
- A small Virtual machine, [Azure](https://azure.microsoft.com/en-us/) is ideal.

  
### Clone the power:

```bash
git clone https://github.com/gm3dmo/the-power
```

### Create a virtual environment ([venv](https://docs.python.org/3/library/venv.html)) and activate it:

```bash
cd the-power/http-event-collector
python -m venv .venv
source .venv/bin/activate
```

### Install the required dependencies in the virtual environment:

```bash
pip install -r requirements.txt
```

### Proxy Configuration
I'm using one called [Caddy](https://caddyserver.com/) but feel free to use one you prefer. This is my caddy configuration file `/etc/caddy/Caddyfile`:

```bash
{
 debug
 servers {
 protocols h2
 protocols h1
 }
}                                                                                                                          audit.seyosh.org {
    header Custom-Header "the-power-http-event-collector"
    root * /usr/share/caddy
    file_server
        @http2only {
    }                                                                                                                                 reverse_proxy 127.0.0.1:8001
}

```

Make sure your proxying web server is running.

## Run the HTTP Collector App

Start the *http-event-collector* application:

```bash
python app.py --username admin --password mysecret --token mytoken
```

The application will run on `http://localhost:8001`

Use username and password in the web UI where you are proxying onto port 8001

The token is the "token" field in your splunk audit log stream in GitHub.

## Send a test message
Open a new window or tmux session (remember you need the virtualenv (.venv) activated

```bash
python test-sender.py --token mytoken
```

## Login to the app and inspect the log

### Login
Login to the app with your username and password:

<img width="1115" alt="event collector login" src="https://github.com/user-attachments/assets/53dd0769-5e8d-44aa-af5b-4434df7f2481" />

### Check the search page
Should contain an event. Press the Show/Hide button to see details of the test message:

<img width="1260" alt="event collector search page" src="https://github.com/user-attachments/assets/e9915c22-a81e-438a-ab23-7d0694c0eb9d" />

## Configure the splunk audit log stream in GitHub

Follow the guidance at [setting up streaming to Splunk](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise#setting-up-streaming-to-splunk) 

<img width="1374" alt="Picture of GitHub Splunk Audit Log Stream Setting page" src="https://github.com/user-attachments/assets/3ea42126-d3d7-4df8-a766-b6e8aa7e7658" />


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
