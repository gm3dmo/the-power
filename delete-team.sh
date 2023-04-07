.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams
# DELETE /orgs/{org}/teams/{team_slug}

# Removes a team from the organization

team_slug=${1}

curl -v ${curl_custom_flags} \
     -X DELETE \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}
