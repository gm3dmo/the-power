.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/assignees?apiVersion=2022-11-28#check-if-a-user-can-be-assigned
# GET /repos/{owner}/{repo}/assignees/{assignee}

if [ -z "$1" ]
  then
    assignee=${pr_approver_name}
  else
    assignee=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/assignees/${assignee}"

