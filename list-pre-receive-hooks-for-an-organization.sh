.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin?apiVersion=2022-11-28#list-pre-receive-hooks-for-an-organization
# GET /orgs/{org}/pre-receive-hooks


if [ -z "$1" ]
  then
    org=${org}
  else
    org=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/pre-receive-hooks"

