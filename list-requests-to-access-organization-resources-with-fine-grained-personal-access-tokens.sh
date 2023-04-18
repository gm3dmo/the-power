.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#list-requests-to-access-organization-resources-with-fine-grained-personal-access-tokens
# GET /organizations/{org}/personal-access-token-requests

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/organizations/${org}/personal-access-token-requests"

