.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-security/configurations?apiVersion=2022-11-28#detach-configurations-from-repositories
# DELETE /orgs/{org}/code-security/configurations/detach

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

json_file=tmp/detach-configurations-from-repositories.json

repository_ids="[1, 2]"

jq -n \
        --argjson repository_ids "${repository_ids}" \
           '{
             "selected_repository_ids": $repository_ids 
           }' > ${json_file}


curl -v ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations/detach"  --data @${json_file}
