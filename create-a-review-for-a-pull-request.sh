.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/reviews?apiVersion=2022-11-28#create-a-review-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/reviews

# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=${default_pull_request_id}
  else
    pull_number=$1
fi

event=${default_pr_event}

body="create-a-review-for-a-pull-request.sh ${event} Review for a pull request @${org}/${team_slug}. Demonstrates [create a review for a pull request](https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/reviews?apiVersion=2022-11-28#create-a-review-for-a-pull-requestt)"



json_file="tmp/create-a-review-for-a-pull-request.json"
jq -n \
       --arg event "$event" \
       --arg body "$body" \
             '{event: $event, body: $body}' > ${json_file}

# The pr_approver_token overrides the default token with one for the pull request approver
# because we may not approve our own pull request.
if [ -z "${pr_approver_token}" ]
  then
    echo "pr_approver_token variable is not set. Exiting." >&2
    exit 1
else
    GITHUB_TOKEN=${pr_approver_token}
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews" --data @${json_file}

