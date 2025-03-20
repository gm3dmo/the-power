# Send a test webhook to the local server
# This script sends a test webhook to the local server using the curl command
# It sets the content type to application/json and the GitHub event type to push
# It also sets the X-Hub-Signature-256 header to a test value
# Finally, it sends the test webhook payload from the test.json file
# Set the url to your server https://your-server.com/webhook

curl -X POST http://localhost:8000/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: push" \
  -H "X-Hub-Signature-256: sha256=test" \
  -d @test.json
