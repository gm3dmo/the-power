.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions
# PUT /orgs/{org}/teams/{team_slug}/repos/{owner}/{repo}

owner=${default_owner}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/repos/${owner}/${repo}" --data '{"permission": "triage" }'

