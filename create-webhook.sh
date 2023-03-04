. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-a-repository-webhook
# POST /repos/:owner/:repo/hooks


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/webhook.json
rm -f ${json_file}

jq -n \
        --arg name "web" \
        --arg webhook_url "${webhook_url}" \
        --arg ct "json" \
        '{
           name: $name,
           active: true,
           events: [
             "commit_comment",
             "create",
             "delete",
             "fork",
             "issue_comment",
             "issues",
             "label",
             "project",
             "push",
             "pull_request",
             "pull_request_review",
             "pull_request_review_comment",
             "release",
             "star"
           ],
           config: {
             url: $webhook_url,
             content_type: $ct,
             insecure_ssl: "0"
           }
         }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks --data @${json_file}
