.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/reviews?apiVersion=2022-11-28#list-comments-for-a-pull-request-review
# GET /repos/{owner}/{repo}/pulls/{pull_number}/reviews/{review_id}/comments

# These values may need to be set for this to work:

if [ -z "$1" ]
  then
    review_id=$(./list-reviews-for-pull-request.sh | jq -r '[.[].id] | max')
  else
    review_id=$1
fi

pull_number=${default_pull_request_id}

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews/${review_id}/comments"

