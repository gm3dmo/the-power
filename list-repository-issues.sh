.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#list-repository-issues
# GET /repos/:owner/:repo/issues

state="all"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues?state=${state}
