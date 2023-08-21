.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#get-a-team-by-name
# GET /orgs/:org/teams/:team_slug

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}
