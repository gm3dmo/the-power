.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/users#create-a-gpg-key-for-the-authenticated-user
# POST /user/gpg_keys

armored_public_key_file=${1:-${my_gpg_pub_key}}
armored_public_key=$(cat ${armored_public_key_file})

json_file=tmp/add-gpg-key.json
ts=$(date +%s)

DATA=$( jq -n \
                --arg armored_public_key "${armored_public_key}" \
                '{armored_public_key: $armored_public_key}' )
echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/user/gpg_keys --data @${json_file}
