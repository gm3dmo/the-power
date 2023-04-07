.  ./.gh-api-examples.conf

# https://developer.github.com/v3/repos/#list-repository-languages
# GET /repos/:owner/:repo/languages

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/languages
