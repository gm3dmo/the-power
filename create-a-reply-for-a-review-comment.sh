.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/comments?apiVersion=2022-11-28#create-a-reply-for-a-review-comment
# POST /repos/{owner}/{repo}/pulls/{pull_number}/comments/{comment_id}/replies


if [ -z "$1" ]
  then
    comment_id=$(./list-review-comments-on-pull-request.sh| jq -r '[.[].id] | max ')
  else
    comment_id=$1
fi

pull_number=${default_pull_request_id}

json_file=tmp/create-a-reply-for-a-review-comment.json

body="review comment reply the power"

jq -n \
           --arg body "${body}" \
           '{
             body: $body
           }' > ${json_file}


set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pulls/${pull_number}/comments/${comment_id}/replies"  --data @${json_file}

