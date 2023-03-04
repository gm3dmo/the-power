. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#get-allowed-actions-for-an-organization
# GET /orgs/{org}/actions/permissions/selected-actions

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/actions/permissions/selected-actions
