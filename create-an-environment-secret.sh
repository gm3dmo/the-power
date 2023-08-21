.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#create-or-update-an-environment-secret
# PUT /repositories/{repository_id}/environments/{environment_name}/secrets/{secret_name}

json_file=tmp/environment-secret.json
rm -f ${json_file}

environment_name=${default_environment_name}
secret_name=${environment_secret_name}

key_id=$(./get-an-environment-public-key.sh | jq -r '.key_id')
environment_public_key=$(./get-an-environment-public-key.sh | jq -r '.key')

encrypted_value=$(ruby create-an-environment-secret-helper.rb ${environment_public_key})

jq -n \
           --arg secret_name "${secret_name}" \
           --arg key_id "${key_id}" \
           --arg encrypted_value "${encrypted_value}" \
           '{
             secret_name: $secret_name,
             key_id: $key_id,
             encrypted_value: $encrypted_value
           }' > ${json_file}

repository_id=$(./list-repo.sh $repo | jq -r '.id')

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repositories/${repository_id}/environments/${environment_name}/secrets/${secret_name} --data @${json_file}
