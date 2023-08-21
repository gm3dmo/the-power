.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#list-team-members
# GET /orgs/:org/teams/:team_slug/members

# Providing a team slug as the argument overrides the default 
# value of *team_slug* in  `.gh-api-examples.conf`
# If the script is passed an argument $1 use that as the *team-slug*

if [ -z "$1" ]
  then
    team_slug=${team_slug}
  else
    team_slug=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/members
