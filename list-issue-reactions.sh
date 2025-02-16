.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-an-issue
# GET /repos/{owner}/{repo}/issues/{issue_number}/reactions


if [ -z "$1" ]
  then
    issue_number=${default_issue_id}
  else
    issue_number=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_number}/reactions"

