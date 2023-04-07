.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/reactions#create-reaction-for-an-issue
# POST /repos/{owner}/{repo}/issues/{issue_number}/reactions


if [ -z "$1" ]
  then
    issue_number=${default_issue_id}
  else
    issue_number=$1
fi

set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_number}/reactions --data '{"content":"rocket"}'
