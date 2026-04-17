.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/assignees?apiVersion=2022-11-28#remove-assignees-from-an-issue
# DELETE /repos/{owner}/{repo}/issues/{issue_number}/assignees

if [ -z "$1" ]
  then
    user_to_unassign=$pr_approver_name
  else
    user_to_unassign=$1
fi

issue_number=${default_issue_id}

json_file=tmp/remove-assignees-from-an-issue.json

jq -n \
           --arg user_to_unassign "${user_to_unassign}" \
           '{
             assignees: $user_to_unassign,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/issues/${issue_number}/assignees" --data @${json_file}
