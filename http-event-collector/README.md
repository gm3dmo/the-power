# Splunk HTTP Event Collector (HEC) Receiver

This Flask application acts as a receiver for events and forwards them to Splunk using the HTTP Event Collector (HEC). It's designed to be a middleware that can receive events from various sources and forward them to Splunk.

## Setup

1. Install the required dependencies:
```bash
pip install -r requirements.txt
```

2. Create a `.env` file with your Splunk HEC configuration:
```bash
SPLUNK_HEC_URL=https://your-splunk-instance:8088/services/collector
SPLUNK_HEC_TOKEN=your-token-here
```

## Running the Application

Start the Flask application:
```bash
python app.py
```

The application will run on `http://localhost:8002`

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