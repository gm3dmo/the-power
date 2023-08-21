.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#list-comments-for-a-pull-request-review
# GET /repos/{owner}/{repo}/pulls/{pull_number}/reviews/{review_id}/comments

# These values may need to be set for this to work:

if [ -z "$1" ]
  then
    review_id=1
  else
    review_id=$1
fi

pull_number=${default_pull_request_id}

set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews/${review_id}/comments
