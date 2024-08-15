.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-security/configurations?apiVersion=2022-11-28#get-code-security-configurations-for-an-organization
# GET /orgs/{org}/code-security/configurations


if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations"

