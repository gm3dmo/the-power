.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/pulls/reviews#dismiss-a-review-for-a-pull-request
# PUT /repos/{owner}/{repo}/pulls/{pull_number}/reviews/{review_id}/dismissals


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    review_id=${review_id}
  else
    review_id=$1
fi

pull_number=${default_pull_request_id}

json_file=tmp/dismiss-a-review-for-a-pull-request.json

jq -n \
           --arg name "${repo}" \
           '{
             message : "need to dismiss this pull request. sorry.",
           }' > ${json_file}

set -x
curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews/${review_id}/dismissals --data @${json_file}
