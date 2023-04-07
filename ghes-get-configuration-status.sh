.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#get-the-configuration-status
# GET /setup/api/configcheck

curl -v -L ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
        https://api_key:${admin_password}@${hostname}:8443/setup/api/configcheck
