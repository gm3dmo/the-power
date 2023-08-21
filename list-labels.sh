.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#list-labels-for-a-repository
# GET /repos/:owner/:repo/labels

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/labels
