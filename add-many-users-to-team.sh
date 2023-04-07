.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#add-or-update-team-membership-for-a-user
# PUT /orgs/:org/teams/:team_slug/memberships/:username

# This assumes you have created a file called tmp/longlistofpeople.txt
# you can use generate-long-list-of-people.pl to do that or put in your own list

team_id=$(curl ${curl_custom_flags} -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

for team_member in $(cat tmp/longlistofpeople.txt)
do
  curl ${curl_custom_flags} \
      -X PUT \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         ${GITHUB_API_BASE_URL}/teams/${team_id}/memberships/${team_member}
done
