. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#add-an-authorized-ssh-key
# POST /setup/api/settings/authorized-keys

public_key_file=${1:-${my_ssh_pub_key}}

curl -L ${curl_custom_flags} \
        https://api_key:${admin_password}@${hostname}:8443/setup/api/settings/authorized-keys -F "authorized_key=@${public_key_file}"

