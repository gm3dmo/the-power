.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/teams/teams#check-team-permissions-for-a-repository
# GET /orgs/{org}/teams/{team_slug}/repos/{owner}/{repo}

curl -I ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/repos/${org}/${repo}
