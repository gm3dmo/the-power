.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/cache?apiVersion=2022-11-28#list-repositories-with-github-actions-cache-usage-for-an-organization
# GET /orgs/{org}/actions/cache/usage-by-repository

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
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/cache/usage-by-repository"
