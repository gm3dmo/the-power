import requests
import json
import random
import string
import time
import argparse
from datetime import datetime

def generate_request_id():
    """Generate a random request ID in the format: 0123456789abcdef"""
    return ''.join(random.choices(string.hexdigits.lower(), k=16))

def generate_document_id():
    """Generate a random document ID in the format 6zPzb34RAswZoaYStrFiJA"""
    return ''.join(random.choices(string.ascii_letters + string.digits, k=22))

def generate_hashed_token():
    """Generate a random hashed token in the format +c7Iz8LEKNhhsSxDJ6F/b9b7Y91WyOS5MpbWqRsdzWc="""
    return ''.join(random.choices(string.ascii_letters + string.digits + '+/=', k=44))

def send_event(url, token, event_data):
    """Send an event to the HEC endpoint"""
    headers = {
        'Authorization': f'Splunk {token}',
        'Content-Type': 'application/json'
    }
    
    try:
        response = requests.post(url, headers=headers, json=event_data)
        response.raise_for_status()
        print(f"Event sent successfully. Status: {response.status_code}")
        print(f"Response: {response.text}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"Error sending event: {str(e)}")
        if hasattr(e.response, 'text'):
            print(f"Response: {e.response.text}")
        return False

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Send test events to HEC endpoint')
    parser.add_argument('--token', required=True, help='Authentication token for the collector')
    parser.add_argument('--url', default='http://localhost:8001/services/collector', help='HEC endpoint URL')
    args = parser.parse_args()

    # Generate a random request ID
    request_id = generate_request_id()
    print(f"Generated request ID: {request_id}")

    # Create the event data
    event_data = {
        "request_id": request_id,
        "timestamp": datetime.now().isoformat(),
        "event": {
            "action": "repo.create",
            "actor": "test-user",
            "actor_id": 12345,
            "actor_location": {
                "country_code": "US"
            },
            "repo": {
                "id": 67890,
                "name": "test-repo",
                "url": "https://github.com/test-org/test-repo"
            },
            "user": {
                "id": 12345,
                "login": "test-user",
                "url": "https://github.com/test-user"
            }
        }
    }

    # Send the event
    print("\nSending event:")
    print(json.dumps(event_data, indent=2))
    success = send_event(args.url, args.token, event_data)

    if success:
        print("\nEvent sent successfully!")
    else:
        print("\nFailed to send event.")

if __name__ == "__main__":
    main() 
