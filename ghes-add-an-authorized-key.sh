. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#add-an-authorized-ssh-key
# POST /setup/api/settings/authorized-keys

authorized_key=$(cat ${my_ssh_pub_key})
 
curl -v -L ${curl_custom_flags} \
     -X POST \
      -H "Accept: application/x-www-form-urlencoded" \
        https://api_key:${admin_password}@${hostname}/setup/api/settings/authorized-keys --data-urlencode "authorized_key=${authorized_key}"
