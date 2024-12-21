.   ./.gh-api-examples.conf


# run this script after create-teams-for-repository-permission.sh
#
#

permissions=("pull" "triage" "push" "maintain" "admin")
team_members_array=($team_members)

prefix=pwr

for i in "${!permissions[@]}"; do
    team_permission="${permissions[i]}"
    team_member="${team_members_array[i]}"
    
    team_name=${prefix}-team-${team_permission}
    team_slug=${team_name}
    team_id=$(curl ${curl_custom_flags} -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')
    
    echo "${team_member} ---> ${team_permission}"
    
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${GITHUB_API_BASE_URL}/teams/${team_id}/memberships/${team_member}"
done
