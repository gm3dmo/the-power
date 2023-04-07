.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/activity#list-public-organization-events
# GET /orgs/{org}/events


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/events

