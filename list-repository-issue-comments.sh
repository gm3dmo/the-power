.  ./.gh-api-examples.conf

# Get the comments on an issue
# https://docs.github.com/en/rest/reference/issues#list-issue-comments
# GET /repos/:owner/:repo/issues/:issue_number/comments

issue_id=${1:-1}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.full+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_id}/comments
