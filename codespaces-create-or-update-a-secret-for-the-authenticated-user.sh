.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/secrets?apiVersion=2022-11-28#create-or-update-a-secret-for-the-authenticated-user
# PUT /user/codespaces/secrets/{secret_name}


key_id=$(./codespaces-get-public-key-for-authenticated-user.sh | jq -r '.key_id')
public_key=$(./codespaces-get-public-key-for-authenticated-user.sh | jq -r '.key')
encrypted_value=$(ruby create-a-repository-secret-helper.rb ${public_key} ${codespaces_secret_001})
secret_name=codespaces_secret_001


json_file=tmp/create-or-update-a-secret-for-the-authenticated-user.json

jq -n \
           --arg encrypted_value  "${encrypted_value}" \
           --arg key_id "${key_id}" \
           '{
             encrypted_value : $encrypted_value,
             key_id: $key_id
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/codespaces/secrets/${secret_name}"  --data @${json_file}

