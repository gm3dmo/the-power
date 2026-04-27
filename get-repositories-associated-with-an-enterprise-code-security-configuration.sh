.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#get-repositories-associated-with-an-enterprise-code-security-configuration
# GET /enterprises/{enterprise}/code-security/configurations/{configuration_id}/repositories

if [ -z "$1" ]
  then
    enterprise=${enterprise}
  else
    enterprise=$1
fi

configuration_id=$(./get-code-security-configurations-for-an-enterprise.sh | jq '[.[].id] | max')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/code-security/configurations/${configuration_id}/repositories"
