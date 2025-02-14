.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/gists/gists?apiVersion=2022-11-28#list-gists-for-a-user
# GET /users/{username}/gists


if [ -z "$1" ]
  then
    username=${admin_user}
  else
    username=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/users/${username}/gists"

