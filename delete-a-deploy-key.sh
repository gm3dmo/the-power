.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/deploy-keys/deploy-keys?apiVersion=2022-11-28#delete-a-deploy-key
# DELETE /repos/{owner}/{repo}/keys/{key_id}

key_id=$1

curl -v ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/keys/${key_id}"
