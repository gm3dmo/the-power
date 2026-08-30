.  ./.gh-api-examples.conf


# https://docs.github.com/en/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#list-fine-grained-personal-access-tokens-with-access-to-organization-resources
# GET /orgs/{org}/personal-access-tokens


if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


GITHUB_TOKEN=$(./ent-call-get-installation-token.sh | jq -r '.token')

set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/personal-access-tokens"

