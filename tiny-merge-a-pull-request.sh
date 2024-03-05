.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#merge-a-pull-request
# PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge



# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=2
  else
    pull_number=$1
fi

commit_title="PR commit title"
commit_message="PR commit message."

json_file=tmp/merge-a-pull-request.json

jq -n \
           --arg commit_title "${commit_title}" \
           --arg commit_message "${commit_message}" \
           --arg merge_method "${merge_method}" \
           '{
             commit_title : $commit_title,
             commit_message : $commit_message,
             merge_method: $merge_method,
           }' > ${json_file}


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/merge" --data @${json_file}

