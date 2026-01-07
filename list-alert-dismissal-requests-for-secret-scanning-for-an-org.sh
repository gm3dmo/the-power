.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/secret-scanning/alert-dismissal-requests?apiVersion=2022-11-28#list-alert-dismissal-requests-for-secret-scanning-for-an-org
# GET /orgs/{org}/dismissal-requests/secret-scanning


if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/dismissal-requests/secret-scanning"

