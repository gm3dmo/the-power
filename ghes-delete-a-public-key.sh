. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#delete-a-public-key
# DELETE /admin/keys/{key_ids}

public_key_file=${1:-${my_ssh_pub_key}}

key_ids=$1

curl -L ${curl_custom_flags} \
     -X DELETE \
        https://api_key:${admin_password}@${hostname}/admin/keys/${key_ids}

