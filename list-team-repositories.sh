.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#list-team-repositories
# GET /orgs/{org}/teams/{team_slug}/repos

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/repos
