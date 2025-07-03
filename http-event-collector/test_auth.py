#!/usr/bin/env python3
"""
Test script to verify authentication is working in the HTTP Event Collector.
This tests the fix for the security vulnerability described in test-data/lorem-issue.md
"""

import requests
import json
import sys
import time
import subprocess
import signal
import threading
from datetime import datetime

def test_authentication(base_url="http://localhost:8001"):
    """Test authentication with valid and invalid tokens"""
    
    # Test cases
    test_cases = [
        {
            "name": "Valid token",
            "token": "valid-test-token",
            "expected_status": 200,
            "description": "Should accept requests with valid token"
        },
        {
            "name": "Invalid token",
            "token": "invalid-token",
            "expected_status": 401,
            "description": "Should reject requests with invalid token"
        },
        {
            "name": "Dogs token (🐾)",
            "token": "woof-woof-🐾",
            "expected_status": 401,
            "description": "Should reject dogs (unauthorized access)"
        },
        {
            "name": "Random token",
            "token": "abc123xyz",
            "expected_status": 401,
            "description": "Should reject random tokens"
        }
    ]
    
    results = []
    
    for test_case in test_cases:
        print(f"\nTesting: {test_case['name']}")
        print(f"Description: {test_case['description']}")
        
        # Prepare test event
        event_data = {
            "test_event": True,
            "timestamp": datetime.now().isoformat(),
            "action": "auth_test",
            "token_test": test_case['name']
        }
        
        headers = {
            'Authorization': f'Splunk {test_case["token"]}',
            'Content-Type': 'application/json'
        }
        
        try:
            response = requests.post(
                f"{base_url}/services/collector",
                headers=headers,
                json=event_data,
                timeout=5
            )
            
            status_code = response.status_code
            print(f"Status Code: {status_code}")
            print(f"Response: {response.text}")
            
            # Check if result matches expectation
            success = status_code == test_case['expected_status']
            result = {
                "test": test_case['name'],
                "expected": test_case['expected_status'],
                "actual": status_code,
                "success": success,
                "response": response.text
            }
            results.append(result)
            
            if success:
                print("✅ PASS")
            else:
                print("❌ FAIL")
                
        except requests.exceptions.RequestException as e:
            print(f"❌ REQUEST ERROR: {e}")
            results.append({
                "test": test_case['name'],
                "expected": test_case['expected_status'],
                "actual": "ERROR",
                "success": False,
                "response": str(e)
            })
    
    # Summary
    print("\n" + "="*60)
    print("AUTHENTICATION TEST SUMMARY")
    print("="*60)
    
    passed = sum(1 for r in results if r['success'])
    total = len(results)
    
    for result in results:
        status = "✅ PASS" if result['success'] else "❌ FAIL"
        print(f"{status} {result['test']}: Expected {result['expected']}, Got {result['actual']}")
    
    print(f"\nOverall: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! Authentication is working correctly.")
        return True
    else:
        print("⚠️  Some tests failed! Authentication may not be working correctly.")
        return False

def start_test_server():
    """Start the Flask app with a test token for testing"""
    print("Starting test server...")
    
    # Start the server with a known valid token
    cmd = [
        'python3', 'app.py',
        '--token', 'valid-test-token',
        '--username', 'admin',
        '--password', 'testpass'
    ]
    
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd='/home/runner/work/the-power/the-power/http-event-collector'
    )
    
    # Give the server time to start
    time.sleep(3)
    
    return process

def stop_server(process):
    """Stop the test server"""
    if process:
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()

def main():
    """Main test function"""
    print("🔒 HTTP Event Collector Authentication Test")
    print("Testing fix for the 'dogs accessing database' security vulnerability")
    print("=" * 70)
    
    # Start test server
    server_process = None
    try:
        server_process = start_test_server()
        
        # Run authentication tests
        success = test_authentication()
        
        return 0 if success else 1
        
    except KeyboardInterrupt:
        print("\nTest interrupted by user")
        return 1
    except Exception as e:
        print(f"Test error: {e}")
        return 1
    finally:
        if server_process:
            stop_server(server_process)
            print("\nTest server stopped")

if __name__ == "__main__":
    sys.exit(main())