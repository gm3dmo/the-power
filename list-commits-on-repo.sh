.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28
# GET /repos/:owner/:repo/commits

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits
