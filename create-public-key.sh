.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/users#create-a-public-ssh-key-for-the-authenticated-user
# POST /user/keys

public_key_file=${1:-${my_ssh_pub_key}}
public_key=$(cat ${public_key_file})

json_file=tmp/ssh-key.json
ts=$(date +%s)

DATA=$( jq -n \
                --arg title "ssh key uploaded ${ts}" \
                --arg key "${public_key}" \
                '{title: $title, key: $key}' )
echo $DATA > ${json_file}


curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/user/keys --data @${json_file}
