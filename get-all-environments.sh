.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-all-environments
# GET /repos/{owner}/{repo}/environments

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/environments
