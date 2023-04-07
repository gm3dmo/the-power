.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#list-child-teams
# GET /orgs/:org/teams/:team_slug/teams

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/teams
