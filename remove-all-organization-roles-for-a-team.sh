.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/organization-roles?apiVersion=2022-11-28#remove-all-organization-roles-for-a-team
# DELETE /orgs/{org}/organization-roles/teams/{team_slug}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    team_slug=$team_slug
  else
    team_slug=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles/teams/${team_slug}"

