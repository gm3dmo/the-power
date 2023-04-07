.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/reference/code-scanning#list-code-scanning-alerts-for-a-repository
# GET /repos/{owner}/{repo}/code-scanning/alerts


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/code-scanning/alerts
