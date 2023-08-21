.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#add-or-update-team-project-permissions
# PUT /orgs/:org/teams/:team_slug/projects/:project_id

project_id=$(./list-organization-projects.sh 2>/dev/null | jq '.[] | .id' | sort | head -1) 

json_file=test-data/team-permissions.json

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.inertia-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/projects/${project_id} --data @${json_file}
