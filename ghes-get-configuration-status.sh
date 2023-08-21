.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#get-the-configuration-status
# GET /setup/api/configcheck

curl -L ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
        "https://api_key:${mgmt_password}@${hostname}:${mgmt_port}/setup/api/configcheck"
