.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/codespaces/repository-secrets?apiVersion=2022-11-28#create-or-update-a-repository-secret
# PUT /repos/{owner}/{repo}/codespaces/secrets/{secret_name}


## Beware of how closely these two urls resemble each other

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/secrets?apiVersion=2022-11-28#create-or-update-a-repository-secret
#                                                         ^^^^^^^ @@@@@@@                       ------------------------------------
# versus:
# https://docs.github.com/en/enterprise-cloud@latest/rest/codespaces/repository-secrets?apiVersion=2022-11-28#create-or-update-a-repository-secret
#                                                         ^^^^^^^^^^ @@@@@@@@@@@@@@@@@@                       ------------------------------------

# They each have their own separate keys hence get-a-repository-codespaces-public-key.sh


ts=$(date +%s)
repo_secret_name="pwr_codespaces_secret"
repo_secret_value="pwr-codespaces-secret-phrase"

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


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/codespaces/secrets/${secret_name}" --data @${json_file}

