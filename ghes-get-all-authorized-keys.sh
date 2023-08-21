.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/management-console?apiVersion=2022-11-28#get-all-authorized-ssh-keys
# GET /setup/api/settings/authorized-keys


curl -L ${curl_custom_flags} \
        https://api_key:${mgmt_password}@${hostname}:${mgmt_port}/setup/api/settings/authorized-keys

