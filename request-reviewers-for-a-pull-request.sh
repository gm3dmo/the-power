.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/pulls/review-requests#request-reviewers-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/requested_reviewers

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

reviewer=${default_committer}
pull_number=${default_pull_request_id}

json_file=tmp/request-reviewers-for-a-pull-request.json

jq -n \
           --arg reviewer "${reviewer}" \
           '{
             reviewers : [ $reviewer ]
           }' > ${json_file}

set -x
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/requested_reviewers --data @${json_file}


