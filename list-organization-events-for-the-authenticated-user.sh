.  ./.gh-api-examples.conf

# https://docs.github.com/en/free-pro-team@latest/rest/activity/events?apiVersion=2022-11-28#list-organization-events-for-the-authenticated-user
# GET /users/{username}/events/orgs/{org}


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

username=$2

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/users/${username}/events/orgs/${org}"  
