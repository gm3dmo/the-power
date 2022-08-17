. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#get-an-organization
# GET /orgs/:org

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}
