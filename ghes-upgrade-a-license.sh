.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/management-console?apiVersion=2022-11-28#upgrade-a-license
# POST /setup/api/upgrade

curl -L ${curl_custom_flags} \
        "https://api_key:${admin_password}@${hostname}:${mgmt_port}/setup/api/upgrade" -F "license=@enterprise.ghl"
