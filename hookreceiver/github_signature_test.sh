#!/bin/bash

# GitHub's example values from documentation
# https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries
SECRET="It's a Secret to Everybody"
PLAIN_PAYLOAD="Hello, World!"
EXPECTED_SIGNATURE="757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17"

# Calculate our own signature to verify understanding
CALCULATED_SIGNATURE=$(echo -n "$PLAIN_PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')

# Display verification information
echo "=== GITHUB WEBHOOK SIGNATURE VALIDATION TEST ==="
echo "Secret: '$SECRET'"
echo "Payload: '$PLAIN_PAYLOAD'"
echo "Expected signature: $EXPECTED_SIGNATURE"
echo "Calculated signature: $CALCULATED_SIGNATURE"

if [ "$CALCULATED_SIGNATURE" = "$EXPECTED_SIGNATURE" ]; then
    echo "✅ Our signature calculation matches GitHub's expected result"
else
    echo "❌ Our signature calculation DOES NOT match GitHub's expected result"
    echo "   Please check the HMAC-SHA256 implementation"
    exit 1
fi

# Save the payload to a file
echo -n "$PLAIN_PAYLOAD" > plain_payload.txt

echo -e "\n=== TESTING WEBHOOK VALIDATION ==="
echo "Sending exact 'Hello, World!' payload to the webhook receiver"
echo "Checking if your implementation can properly validate the signature"

# Send the webhook with exact plain payload, making sure Content-Type is treated correctly
curl -X POST http://localhost:8000/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -H "X-Hub-Signature-256: sha256=$EXPECTED_SIGNATURE" \
  --data-binary "$PLAIN_PAYLOAD"

echo -e "\n\nDone! Check your webhook receiver for validation results."
echo "Clean up temporary files..."
rm plain_payload.txt
echo "Complete!" 