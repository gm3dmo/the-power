.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/members?apiVersion=2022-11-28#remove-an-organization-member
# DELETE /orgs/{org}/members/{username}


if [ -z "$1" ]
  then
    username=${default_committer}
  else
    username=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/member/${username}"

