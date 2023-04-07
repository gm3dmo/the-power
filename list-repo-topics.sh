.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-all-repository-topics
# GET /repos/{owner}/{repo}/topics


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.mercy-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/topics
