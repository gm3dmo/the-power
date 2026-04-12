.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/deploy-keys/deploy-keys?apiVersion=2022-11-28#get-a-deploy-key
# GET /repos/{owner}/{repo}/keys/{key_id}

if [ -z "$1" ]
  then
    key_id=$(./list-deploy-keys.sh | jq -r '.[0].id')
  else
    key_id=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/keys/${key_id}"
