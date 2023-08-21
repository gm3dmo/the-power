.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#get-a-review-for-a-pull-request
# GET /repos/:owner/:repo/pulls/:pull_number/reviews/:review_id

pull=2
review_id=1

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull}/reviews/${review_id}
