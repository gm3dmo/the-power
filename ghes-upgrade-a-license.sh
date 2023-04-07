.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.3/rest/reference/enterprise-admin#upgrade-a-license
# POST /setup/api/upgrade

curl -L ${curl_custom_flags} \
        https://api_key:${admin_password}@${hostname}:8443/setup/api/upgrade -F "license=@enterprise.ghl"
