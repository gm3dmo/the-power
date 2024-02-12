.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/contents?apiVersion=2022-11-28#delete-a-file
# DELETE /repos/{owner}/{repo}/contents/{path}


json_file=tmp/skeleton.json

jq -n \
           --arg name "${repo}" \
           '{
             name : $name,
           }' > ${json_file}


path=/docs/README.md

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/contents/${path}"
