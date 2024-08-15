.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-security/configurations?apiVersion=2022-11-28#attach-a-configuration-to-repositories
# POST /orgs/{org}/code-security/configurations/{configuration_id}/attach


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

json_file=tmp/attach-a-configuration-to-repositories.json

scope="selected"
selected_repository_ids="[843055762]"

jq -n \
           --arg scope "${scope}" \
           --argjson selected_repository_ids "${selected_repository_ids}" \
           --arg selected_repository_ids "${selected_repository_ids}" \
           '{
             scope: $scope,
             selected_repository_ids: $selected_repository_ids,
           }' > ${json_file}


configuration_id=$(./get-code-security-configurations-for-an-organization.sh | jq '[.[].id] | max')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations/${configuration_id}/attach"  --data @${json_file}
