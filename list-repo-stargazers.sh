.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/activity#list-stargazers
# GET /repos/{owner}/{repo}/stargazers

name=${1:-repo}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/stargazers
