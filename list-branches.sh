.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#list-branches 
# GET /repos/{owner}/{repo}/branches

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches #| jq '.[] | {name: .name, commit: .commit}'

