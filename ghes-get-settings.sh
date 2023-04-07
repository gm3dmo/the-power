.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#get-settings
# GET /setup/api/settings
 
curl -L ${curl_custom_flags} \
        https://api_key:${admin_password}@${hostname}:8443/setup/api/settings
