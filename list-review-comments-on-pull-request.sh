.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#list-review-comments-on-a-pull-request
# GET /repos/{owner}/{repo}/pulls/{pull_number}/comments

pull_number=${default_pull_request_id}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/comments
