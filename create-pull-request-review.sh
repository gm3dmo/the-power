. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#create-a-review-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/reviews

# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=${default_pull_request_id}
  else
    pull_number=$1
fi

event="APPROVE"
body="${event} Spatium tantummodo huiusmodi stercore cadet scribat. Probatus.  Certainly check in with @${org}/${team_slug} who may be interested."

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
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews --data @${json_file}
