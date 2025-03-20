#!/bin/bash

# GitHub's example values from documentation
# https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries
SECRET="It's a Secret to Everybody"
PLAIN_PAYLOAD="Hello, World!"
EXPECTED_SIGNATURE="757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17"

# Calculate our own signature to verify understanding
# The -n flag for echo is crucial - it prevents adding a newline character
CALCULATED_SIGNATURE=$(echo -n "$PLAIN_PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')

# Display verification information
echo "=== GITHUB WEBHOOK SIGNATURE VALIDATION TEST ==="
echo "Secret: '$SECRET'"
echo "Payload: '$PLAIN_PAYLOAD'"
echo "Expected signature: $EXPECTED_SIGNATURE"
echo "Calculated signature: $CALCULATED_SIGNATURE"

if [ "$CALCULATED_SIGNATURE" = "$EXPECTED_SIGNATURE" ]; then
    echo "✅ SUCCESS! Our signature calculation matches GitHub's expected result"
    echo "Your HMAC-SHA256 implementation is working correctly!"
else
    echo "❌ FAILURE! Our signature calculation DOES NOT match GitHub's expected result"
    echo "Please check your HMAC-SHA256 implementation"
    echo
    echo "Debug details:"
    echo "- Check that the -n flag is used with echo to prevent trailing newline"
    echo "- Make sure the exact string 'Hello, World!' is used (without quotes)"
    echo "- Verify the secret is exactly: It's a Secret to Everybody"
    echo "- Check that the HMAC is using SHA-256 algorithm"
fi

# Additional validation - show the exact bytes being hashed
echo
echo "=== HEX DEBUGGING ==="
echo "Payload as hex bytes:" 
echo -n "$PLAIN_PAYLOAD" | xxd -p

# Show the openssl command with verbose output
echo
echo "=== OPENSSL VERBOSE OUTPUT ==="
echo -n "$PLAIN_PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" -debug

echo
echo "=== Python equivalent command ==="
echo "import hmac, hashlib"
echo "secret = \"It's a Secret to Everybody\""
echo "payload = \"Hello, World!\""
echo "signature = hmac.new(secret.encode('utf-8'), payload.encode('utf-8'), hashlib.sha256).hexdigest()"
echo "print(signature)"
echo "print(signature == \"$EXPECTED_SIGNATURE\")" 