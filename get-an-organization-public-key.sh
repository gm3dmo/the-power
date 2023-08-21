.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#get-an-organization-public-key
# GET /orgs/{org}/actions/secrets/public-key

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/actions/secrets/public-key
