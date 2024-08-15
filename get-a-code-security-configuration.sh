.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-security/configurations?apiVersion=2022-11-28#get-a-code-security-configuration
# GET /orgs/{org}/code-security/configurations/{configuration_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi



configuration_id=$(./get-code-security-configurations-for-an-organization.sh | jq '[.[].id] | max')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations/${configuration_id}"
