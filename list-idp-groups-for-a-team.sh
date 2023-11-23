.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/team-sync?apiVersion=2022-11-28#list-idp-groups-for-a-team
# GET /orgs/{org}/teams/{team_slug}/team-sync/group-mappings

team_id=$(curl ${curl_custom_flags} --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/team-sync/group-mappings"
