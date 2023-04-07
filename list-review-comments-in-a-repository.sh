.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#list-review-comments-in-a-repository
# GET /repos/{owner}/{repo}/pulls/comments


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pulls/comments
