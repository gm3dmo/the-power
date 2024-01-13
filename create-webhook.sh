.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/webhooks/repos?apiVersion=2022-11-28#create-a-repository-webhook
# POST /repos/{owner}/{repo}/hooks

# Events: https://docs.github.com/en/webhooks/webhook-events-and-payloads


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
             "branch_protection_rule",
             "branch_protection_configuration",
             "commit_comment",
             "check_run",
             "check_suite",
             "code_scanning_alert",
             "commit_comment",
             "create",
             "delete",
             "dependabot_alert",
             "deploy_key",
             "deployment",
             "deployment_status",
             "discussion",
             "discussion_comment",
             "fork",
             "gollum",
             "issue_comment",
             "issues",
             "label",
             "project",
             "merge_group",
             "member",
             "meta",
             "milestone",
             "package",
             "page_build",
             "project",
             "project_card",
             "project_column",
             "public",
             "push",
             "pull_request",
             "pull_request_review",
             "pull_request_review_comment",
             "pull_request_review_thread",
             "registry_package",
             "release",
             "repository",
             "repository_advisory",
             "repository_import",
             "repository_ruleset",
             "repository_vulnerability_alert",
             "secret_scanning_alert",
             "secret_scanning_alert_location",
             "security_and_analysis",
             "star",
             "status",
             "team_add",
             "watch",
             "workflow_job",
             "workflow_run"

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
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks" --data @${json_file}
