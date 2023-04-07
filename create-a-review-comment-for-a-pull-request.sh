.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#create-a-review-comment-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/comments


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    pull_number=${default_pull_request_id}
  else
    pull_number=$1
fi

json_file=tmp/create-a-review-comment-for-a-pull-request.json

# Beware. We are extracting the first commit in the pull request here.
# you may wan to do something else:
commit_id=$(./list-commits-on-a-pull-request.sh | jq -r '.[0].sha')

pull_request_review_body_comment="Great Stuff"
path="docs/new-file-for-pull-request-txt"
start_line=1
start_side=RIGHT
line=2
side=RIGHT

jq -n \
           --arg body "${pull_request_review_body_comment}" \
           --arg commit_id  "$commit_id" \
           --arg path "$path" \
           --argjson start_line $start_line \
           --arg start_side "RIGHT" \
           --argjson line $line \
           --arg side "RIGHT" \
           '{
             body : $body,
	     commit_id: $commit_id,
	     path : $path,
	     line : $line,
           }' > ${json_file}


GITHUB_TOKEN=${pr_approver_token}
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/comments --data @${json_file}



