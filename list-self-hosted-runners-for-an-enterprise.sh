.  ./.gh-api-examples.conf

# https://docs.github.com/rest/reference/actions#list-self-hosted-runner-groups-for-an-enterprise
# GET /enterprises/{enterprise}/actions/runner-groups

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/runner-groups
