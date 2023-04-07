.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#add-or-update-team-membership-for-a-user
# PUT /orgs/:org/teams/:team_slug/memberships/:username

team_id=$(curl ${curl_custom_flags} --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

for team_member in ${team_members}
do
  echo "======================== ${team_member} ==========================" >&2
  curl --silent ${curl_custom_flags} \
      -X PUT \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/teams/${team_id}/memberships/${team_member}
done
