.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#list-pull-requests
# GET /repos/:owner/:repo/pulls

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls
