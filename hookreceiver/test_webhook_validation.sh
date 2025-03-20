#!/bin/bash

# Test values
SECRET="It's a Secret to Everybody"
PAYLOAD='{"message": "Hello, World!"}'
EXPECTED_SIGNATURE="757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17"

# Create a temporary JSON file with the test payload
echo "$PAYLOAD" > test_payload.json

# Generate the signature (for verification)
GENERATED_SIGNATURE=$(echo -n "$PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')

# Display verification info
echo "Secret: $SECRET"
echo "Payload: $PAYLOAD"
echo "Expected signature: $EXPECTED_SIGNATURE"
echo "Generated signature: $GENERATED_SIGNATURE"

if [ "$GENERATED_SIGNATURE" = "$EXPECTED_SIGNATURE" ]; then
    echo "✅ Signatures match! Validation is working correctly."
else
    echo "❌ Signatures don't match! Please check your implementation."
    echo "Note: The expected signature was calculated with plain text 'Hello, World!'"
    echo "      but we're now using JSON format: $PAYLOAD"
fi

# Send the webhook
echo -e "\nSending webhook to http://localhost:8000/webhook...\n"

curl \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -H "X-Hub-Signature-256: sha256=$GENERATED_SIGNATURE" \
  -d "$PAYLOAD" \
      "http://localhost:8000/webhook" \

# Clean up
rm test_payload.json

echo -e "\nDone! Check your webhook receiver for the event." 