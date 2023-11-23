.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#start-a-configuration-process
# POST /setup/api/configure

curl -L ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
        "https://api_key:${admin_password}@${hostname}:${mgmt_port}/setup/api/configure"

