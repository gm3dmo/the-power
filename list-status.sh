.  ./.gh-api-examples.conf

shopt -s -o nounset

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#get-settings
# GET /setup/api/settings
 
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -v -L "https://${hostname}:8443/setup/api/configcheck?api_key=${github_admin_pw}"
