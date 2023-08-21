.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#add-or-update-team-membership-for-a-user
# PUT /orgs/:org/teams/:team_slug/memberships/:username

# Adds a single user to the default team.

# If the script is passed an argument $1 use that as the team name
if [ -z "$1" ]
  then
    team_slug=$team_slug
  else
    team_slug=$1
fi

# If the script is passed an argument $1 use that as the user name
if [ -z "$2" ]
  then
    team_member=$default_committer
  else
    team_member=$2
fi

team_id=$(curl ${curl_custom_flags} -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/teams/${team_id}/memberships/${team_member}
