.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#create-a-review-comment-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/comments


# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=2
  else
    pull_number=$1
fi

# If the script is passed an argument $2 use that as the commit_id
if [ -z "$2" ]
  then
    commit_id=""
  else
    commit_id=$2
fi

# If the script is passed an argument $3 use that as the impersonation_user 
if [ -z "$3" ]
  then
     user_to_impersonate=${default_committer}
  else
     user_to_impersonate=${3}
fi

# If the script is passed an argument $4 use that as what to do with the ticket
if [ -z "$4" ]
  then
     event=${default_pr_event}
     body="create-pull-request-review-comment.sh ${event} Tempus fugit ut sagitta. Fructus volat ut musa.  Certainly check in with @${org}/${team_slug} who may be interested."
  else
     event=$4
     body="${event} Transierunt cum summa gloria. For support @${org}/${team_slug} can help."

fi


path="README.md"
event_body="${body}"


json_file="tmp/create-pull-request-review.json"

jq -n \
       --arg commit_id "$commit_id" \
       --arg event "$event" \
       --arg body "$body" \
             '{event: $event, body: $body}' > ${json_file}

cat ${json_file}

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/reviews --data @${json_file}
