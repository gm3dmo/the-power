.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/contents?apiVersion=2022-11-28#delete-a-file
# DELETE /repos/{owner}/{repo}/contents/{path}


json_file=tmp/skeleton.json

path="docs/README.md"
message="deleiting README.md"

sha=$(curl 'X-GitHub-Api-Version: 2022-11-28' -H 'Accept: application/vnd.github.v3+json' -H "Authorization: Bearer $GITHUB_TOKEN" "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/contents/${path}" | jq -r '.sha')


jq -n \
           --arg message "${message}" \
           --arg name "${default_committer}" \
           --arg sha "${sha}" \
           '{
             message: $message,
             name: $name,
             sha: $sha,
           }' > ${json_file}



set -x
curl -v ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/contents/${path}" --data @$json_file
