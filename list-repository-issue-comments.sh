.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/comments?apiVersion=2022-11-28#list-issue-comments-for-a-repository
# GET /repos/{owner}/{repo}/issues/comments


if [ -z "$1" ]
  then
    issue_id=$default_issue_id
  else
    issue_id=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.full+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_id}/comments"

