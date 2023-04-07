.  ./.gh-api-examples.conf

# https://developer.github.com/v3/teams/
# GET /organizations/:org_id/team/:team_id

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/organizations/4/team/2/members
