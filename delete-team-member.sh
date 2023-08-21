.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#remove-team-membership-for-a-user
# DELETE /orgs/{org}/teams/{team_slug}/memberships/{username}

# Removes a single user from the default team.

team_member=${1}

curl -v ${curl_custom_flags} \
     -X DELETE \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/memberships/${team_member}
