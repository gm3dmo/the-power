.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/outside-collaborators#list-outside-collaborators-for-an-organization
# GET /orgs/{org}/outside_collaborators


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/outside_collaborators
