. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-scanning#list-code-scanning-analyses-for-a-repository
# GET /repos/{owner}/{repo}/code-scanning/analyses

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/code-scanning/analyses
