.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#remove-team-membership-for-a-user
# DELETE /orgs/{org}/teams/{team_slug}/memberships/{username}

team_member=${team_admin}
prefix=pwr

for team_permission in ${available_team_permissions}
do
    team_name=${prefix}-team-${team_permission}
    team_slug=${team_name}
    team_id=$(curl ${curl_custom_flags} -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')
    echo "${team_member} delete ----X> from ${team_name}"

    curl ${curl_custom_flags} \
        -X DELETE \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
           "${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/memberships/${team_member}"
    
done
