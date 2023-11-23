.  ./.gh-api-examples.conf

# https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow
# GET https://github.com/login/oauth/authorize


# # This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com for the device flow.
if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi

# Step 2.
# "code" is the code gathered in the step 1 script. It should have opened in a chrome browser
# with a url like: https://example.com/callback?code=7fb98c2417446ce64c2d
# you need to pass "7fb98c2417446ce64c2d" to this script.

code=$1

client_id=${x_client_id}
client_secret=${x_client_secret}

curl ${curl_custom_flags} -L \
     -H "Accept: application/vnd.github.v3+json" \
     -X POST \
        "http://${hostname}/login/oauth/access_token?client_id=${client_id}&client_secret=${client_secret}&code=${code}" | jq -r
