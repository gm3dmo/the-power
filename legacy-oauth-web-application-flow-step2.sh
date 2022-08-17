. .gh-api-examples.conf

# https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow
# GET https://github.com/login/oauth/authorize

# Step 2.
# code is the code gathered in the step 1 script.

code=$1

client_id=${x_client_id}

curl  -L -v -X POST "http://${hostname}/login/oauth/access_token?client_id=${client_id}&client_secret=${client_secret}&code=${code}"
