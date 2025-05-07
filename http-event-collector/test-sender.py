import requests
import json
import random
import string
import time
from datetime import datetime

def generate_request_id():
    """Generate a random request ID in the format F64B:30BF47:168A5D:1CF3EA:681A7474"""
    # Generate 5 random hex strings of different lengths
    parts = [
        ''.join(random.choices(string.hexdigits.upper(), k=4)),  # 4 chars
        ''.join(random.choices(string.hexdigits.upper(), k=6)),  # 6 chars
        ''.join(random.choices(string.hexdigits.upper(), k=6)),  # 6 chars
        ''.join(random.choices(string.hexdigits.upper(), k=6)),  # 6 chars
        ''.join(random.choices(string.hexdigits.upper(), k=8))   # 8 chars
    ]
    return ':'.join(parts)

def generate_document_id():
    """Generate a random document ID in the format 6zPzb34RAswZoaYStrFiJA"""
    return ''.join(random.choices(string.ascii_letters + string.digits, k=22))

def generate_hashed_token():
    """Generate a random hashed token in the format +c7Iz8LEKNhhsSxDJ6F/b9b7Y91WyOS5MpbWqRsdzWc="""
    return ''.join(random.choices(string.ascii_letters + string.digits + '+/=', k=44))

def send_test_event():
    """Send a test event to the HEC receiver"""
    url = 'http://localhost:8002/services/collector'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Splunk test-token-123'  # Replace with your actual token
    }
    
    # Get current timestamp in milliseconds
    current_time_ms = int(datetime.now().timestamp() * 1000)
    
    # Create test event data
    event_data = {
        "@timestamp": current_time_ms,
        "_document_id": generate_document_id(),
        "action": "api.request",
        "actor": "pipcrispy",
        "actor_id": 63502882,
        "actor_ip": "10.1.1.1",
        "actor_is_bot": False,
        "actor_location": {
            "country_code": "GB"
        },
        "application_name": None,
        "business": "gm3dmo-enterprise-cloud-testing",
        "business_id": 3082,
        "created_at": current_time_ms,
        "hashed_token": generate_hashed_token(),
        "integration": None,
        "operation_type": "access",
        "org": "forest-town",
        "org_id": 86825428,
        "programmatic_access_type": "Personal access token (classic)",
        "public_repo": False,
        "query_string": "",
        "rate_limit_remaining": random.randint(1000, 5000),
        "repo": "forest-town/repo-elfs",
        "repo_id": 978979709,
        "request_access_security_header": None,
        "request_body": "",
        "request_id": generate_request_id(),
        "request_method": random.choice(["GET", "POST", "PUT", "DELETE"]),
        "route": "/repositories/:repository_id/hooks",
        "status_code": random.choice([200, 201, 204, 400, 401, 403, 404, 500]),
        "token_id": 1450686376,
        "token_scopes": "admin:enterprise,admin:gpg_key,admin:org,admin:org_hook,admin:public_key,admin:repo_hook,admin:ssh_signing_key,audit_log,codespace,copilot,delete:packages,delete_repo,gist,notifications,project,repo,user,workflow,write:discussion,write:packages",
        "url_path": "/repositories/978979709/hooks",
        "user": "pipcrispy",
        "user_agent": "curl/8.7.1",
        "user_id": 63502882
    }
    
    try:
        response = requests.post(url, headers=headers, json=event_data)
        response.raise_for_status()
        print(f"Successfully sent event with request_id: {event_data['request_id']}")
        print(f"Response: {response.json()}")
    except requests.exceptions.RequestException as e:
        print(f"Error sending event: {e}")

if __name__ == '__main__':
    print("Starting test sender...")
    print("Press Ctrl+C to stop")
    print("-" * 80)
    
    try:
        while True:
            send_test_event()
            # Wait between 1 and 5 seconds before sending next event
            time.sleep(random.uniform(1, 5))
    except KeyboardInterrupt:
        print("\nStopping test sender...") 