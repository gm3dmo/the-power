.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#delete-a-code-security-configuration
# DELETE /orgs/{org}/code-security/configurations/{configuration_id}

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

configuration_id=$(./get-code-security-configurations-for-an-organization.sh | jq '[.[].id] | max')

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations/${configuration_id}"
