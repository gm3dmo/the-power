.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#create-a-review-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/reviews


pull_number=${default_pull_request_id}
event="APPROVE"

body="This is an approving review for ${event} Review for a pull request @${org}/${team_slug} "

json_file="tmp/create-approving-review-for-a-pull-request.json"

jq -n \
       --arg event "$event" \
       --arg body "$body" \
             '{event: $event, body: $body}' > ${json_file}

# This overrides the token with a token owned by the pr approver
# because we may not approve our own pull request.
GITHUB_TOKEN=${pr_approver_token}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews --data @${json_file}
