#!/bin/bash

# https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries

# Testing the webhook payload validation
# You can use the following secret and payload values to verify that your implementation is correct:
# 
# secret: It's a Secret to Everybody
# payload: Hello, World!
# If your implementation is correct, the signatures that you generate should match the following signature values:
# 
# signature: 757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17
# X-Hub-Signature-256: sha256=757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17
# 
# # Test values for webhook validation
SECRET="It's a Secret to Everybody"
PLAIN_PAYLOAD="Hello, World!"
JSON_PAYLOAD="{\"message\": \"$PLAIN_PAYLOAD\"}"
EXPECTED_SIGNATURE="757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17"

# Display verification info
echo "Secret: $SECRET"
echo "Original plain text payload: $PLAIN_PAYLOAD"
echo "JSON payload (for webhook): $JSON_PAYLOAD"
echo "Expected signature (from plain text): $EXPECTED_SIGNATURE"

# Calculate signature for the JSON payload
JSON_SIGNATURE=$(echo -n "$JSON_PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')
echo "JSON payload signature: $JSON_SIGNATURE"


echo -e "\n\n1. Testing JSON payload with original signature (will likely fail signature verification):"
echo "======================================================================================="
curl \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -H "X-Hub-Signature-256: sha256=$EXPECTED_SIGNATURE" \
  -d "$JSON_PAYLOAD" \
      "http://localhost:8000/webhook"

echo -e "\n\n2. Testing JSON payload with matching signature (should succeed):"
echo "=================================================================="
curl -X POST http://localhost:8000/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -H "X-Hub-Signature-256: sha256=$JSON_SIGNATURE" \
  -d "$JSON_PAYLOAD" \
  -v

echo -e "\n\nDone! Check your webhook receiver for the events."