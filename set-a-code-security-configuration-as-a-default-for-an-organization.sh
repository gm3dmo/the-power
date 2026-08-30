.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#set-a-code-security-configuration-as-a-default-for-an-organization
# PUT /orgs/{org}/code-security/configurations/{configuration_id}/defaults

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

json_file=tmp/set-a-code-security-configuration-as-a-default-for-an-organization.json

configuration_id=$(./get-code-security-configurations-for-an-organization.sh | jq '[.[].id] | max')

jq -n \
           --arg default_for_new_repos "all" \
           '{
             default_for_new_repos: $default_for_new_repos
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations/${configuration_id}/defaults"  --data @${json_file}
