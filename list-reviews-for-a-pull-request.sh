.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/reviews?apiVersion=2022-11-28#list-reviews-for-a-pull-request
# GET /repos/{owner}/{repo}/pulls/{pull_number}/reviews

pull_number=${default_pull_request_id}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews"

