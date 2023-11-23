.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#create-or-update-a-repository-secret
# PUT /repos/{owner}/{repo}/actions/secrets/{secret_name}


json_file=tmp/repository-secret.json
rm -f ${json_file}

secret_name="THE_POWER_PAT"

key_id=$(./get-a-repository-public-key.sh | jq -r '.key_id')
repo_public_key=$(./get-a-repository-public-key.sh | jq -r '.key')

encrypted_value=$(ruby create-pat-as-repository-secret.rb ${repo_public_key} ${GITHUB_TOKEN})


jq -n \
           --arg secret_name "${secret_name}" \
           --arg key_id "${key_id}" \
           --arg encrypted_value "${encrypted_value}" \
           '{
             secret_name: $secret_name,
             key_id: $key_id,
             encrypted_value: $encrypted_value
           }' > ${json_file}


cat $json_file | jq -r

read x

repository_id=$(./list-repo.sh $repo | jq -r '.id')

set -x
curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/secrets/${secret_name} --data @${json_file}

