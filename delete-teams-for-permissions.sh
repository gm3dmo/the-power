.  ./.gh-api-examples.conf





for permission in ${available_team_permissions}
do
   team_name="${team_permission_prefix}-team-${permission}"
   team_slug=${team_name}
   echo deleting ${team_slug} >&2
    
   curl ${curl_custom_flags} \
        -X DELETE \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
           "${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}"
done
