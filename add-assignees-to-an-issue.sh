.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/assignees?apiVersion=2022-11-28#add-assignees-to-an-issue
# POST /repos/{owner}/{repo}/issues/{issue_number}/assignees


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    user_to_assign=$pr_approver_name
  else
    user_to_assign=$1
fi


issue_number=${default_issue_id}

json_file=tmp/add-assignees-to-an-issue.json

jq -n \
           --arg user_to_assign "${user_to_assign}" \
           '{
             assignees: $user_to_assign,
           }' > ${json_file}



curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/issues/${issue_number}/assignees"  --data @${json_file}

