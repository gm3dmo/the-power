.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#list-sub-issues
# GET /repos/{owner}/{repo}/issues/{issue_number}/sub_issues


# If the script is passed an argument $1 use that as the issue_number
if [ -z "$1" ]
  then
    echo "Error: issue_number is required as first argument"
    exit 1
  else
    issue_number=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/issues/${issue_number}/sub_issues"
