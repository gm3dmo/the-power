.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#timeline
# GET /repos/{owner}/{repo}/issues/{issue_number}/timeline

# If the script is passed an argument $1 use that as the issue
if [ -z "$1" ]
  then
    issue_number=$default_issue_id
  else
    issue_number=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_number}/timeline
