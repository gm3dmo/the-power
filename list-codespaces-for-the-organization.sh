.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/organizations?apiVersion=2022-11-28#list-codespaces-for-the-organization
# GET /orgs/{org}/codespaces


# If the script is passed an argument $1 use that as the name
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
        "${GITHUB_API_BASE_URL}/orgs/${org}/codespaces"
