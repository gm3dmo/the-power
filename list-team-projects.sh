.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/teams/teams?apiVersion=2022-11-28#list-team-projects
# GET /orgs/{org}/teams/{team_slug}/projects


set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/projects

