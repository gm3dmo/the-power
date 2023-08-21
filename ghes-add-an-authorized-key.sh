.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#add-an-authorized-ssh-key
# POST /setup/api/settings/authorized-keys

authorized_key=$(cat ${my_ssh_pub_key})
 
curl -L ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/x-www-form-urlencoded" \
        "https://api_key:${mgmt_password}@${hostname}:${mgmt_port}/setup/api/settings/authorized-keys" --data-urlencode "authorized_key=${authorized_key}"
