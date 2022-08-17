. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#get-all-authorized-ssh-keys
# GET /setup/api/settings/authorized-keys


curl -L ${curl_custom_flags} \
        https://api_key:${admin_password}@${hostname}/setup/api/settings/authorized-keys

