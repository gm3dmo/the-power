.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#attach-an-enterprise-configuration-to-repositories
# POST /enterprises/{enterprise}/code-security/configurations/{configuration_id}/attach

if [ -z "$1" ]
  then
    enterprise=${enterprise}
  else
    enterprise=$1
fi

json_file=tmp/attach-an-enterprise-configuration-to-repositories.json

configuration_id=$(./get-code-security-configurations-for-an-enterprise.sh | jq '[.[].id] | max')

jq -n \
           --arg scope "all" \
           '{
             scope: $scope
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/code-security/configurations/${configuration_id}/attach"  --data @${json_file}
