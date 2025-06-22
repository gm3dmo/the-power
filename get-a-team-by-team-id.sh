.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/teams?apiVersion=2022-11-28#get-a-team-by-name
# which notes: You can also specify a team by org_id and team_id using the route GET /organizations/{org_id}/team/{team_id}.

org_id=$(./list-organization.sh | jq -r '.id')
team_id=$(./get-a-team-by-name.sh | jq -r '.id')

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/organizations/${org_id}/team/${team_id}"

