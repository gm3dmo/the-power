.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#get-an-issue
# GET /repos/:owner/:repo/issues/:issue_number

issue_id=${1:-1}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.full+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_id}
