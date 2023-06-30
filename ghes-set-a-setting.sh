.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#set-settings
# PUT /setup/api/settings

settings='settings={"enterprise": { "public_pages": false }}'
 
curl -L ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/x-www-form-urlencoded" \
        "https://api_key:${admin_password}@${hostname}:${mgmt_port}/setup/api/settings" --data-urlencode "${settings}"
