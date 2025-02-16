.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/reviews?apiVersion=2022-11-28#get-a-review-for-a-pull-request
# GET /repos/{owner}/{repo}/pulls/{pull_number}/reviews/{review_id}

pull=${default_request_id}
review_id=$1

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull}/reviews/${review_id}"

