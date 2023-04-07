.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#add-or-update-team-repository-permissions
# PUT /orgs/:org/teams/:team_slug/repos/:owner/:repo

team_slug="bad-team"

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/vnd.github.hellcat-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/repos/${org}/${repo} --data '{"permission": "push" }'
