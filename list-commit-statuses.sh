.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#list-commit-statuses-for-a-reference
# GET /repos/:owner/:repo/commits/:ref/statuses

target_branch=${1:-new_branch}

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')


curl --silent ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${sha}/statuses?per_page=${per_page}
