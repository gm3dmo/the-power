.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#create-or-update-a-repository-secret
# PUT /repos/{owner}/{repo}/codespaces/secrets/{secret_name}


ts=$(date +%s)
repo_secret_name="codespaces_secret_${ts}"
repo_secret_value="pwr-codespaces-secret"

secret_name=${repo_secret_name}
key_id=$(./get-a-repository-codespaces-public-key.sh | jq -r '.key_id')
repo_public_key=$(./get-a-repository-codespaces-public-key.sh | jq -r '.key')
encrypted_value=$(ruby create-a-repository-secret-helper.rb ${repo_public_key} ${repo_secret_value})
repository_id=$(./list-repo.sh $repo | jq -r '.id')


json_file=tmp/repository-codespaces-secret.json

jq -n \
           --arg secret_name "${secret_name}" \
           --arg key_id "${key_id}" \
           --arg encrypted_value "${encrypted_value}" \
           '{
             secret_name: $secret_name,
             key_id: $key_id,
             encrypted_value: $encrypted_value
           }' > ${json_file}


set -x
curl ${curl_custom_flags} \
     -v \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/codespaces/secrets/${secret_name}" --data @${json_file}

