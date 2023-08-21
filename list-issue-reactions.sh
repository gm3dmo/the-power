.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/reactions#list-reactions-for-an-issue
# GET /repos/{owner}/{repo}/issues/{issue_number}/reactions

issue_number=${default_issue_id}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_number}/reactions
