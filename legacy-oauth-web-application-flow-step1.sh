.  ./.gh-api-examples.conf

# https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow
# GET https://github.com/login/oauth/authorize

# Step 1
# https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#1-request-a-users-github-identity
# GET https://github.com/login/oauth/authorize

# This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com for the device flow.
#
if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi

client_id=${x_client_id}
scope=${oauth_token_scope}
url_encoded_scope=$(printf %s "${scope}" | jq -sRr @uri)

open -n -a "Google Chrome" --args --profile-directory="${chrome_profile}"  "http://${hostname}/login/oauth/authorize?client_id=${client_id}&scope=${url_encoded_scope}"
