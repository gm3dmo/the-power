.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#create-a-review-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/reviews

# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=${default_pull_request_id}
  else
    pull_number=$1
fi

#event="APPROVE"
event=${default_pr_event}
body="create-a-review-for-a-pull-request.sh ${event} Review for a pull request @${org}/${team_slug} "

json_file="tmp/create-pull-request-review.json"

jq -n \
       --arg event "$event" \
       --arg body "$body" \
             '{event: $event, body: $body}' > ${json_file}

# This overrides the token with one for the pull request approver
# because we may not approve our own pull request.
GITHUB_TOKEN=${pr_approver_token}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews --data @${json_file}
