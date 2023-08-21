.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/repos#list-repository-contributors
# GET /repos/{owner}/{repo}/contributors

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contributors
