.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#get-github-actions-permissions-for-a-repository
# GET /repos/{owner}/{repo}/actions/permissions

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
         ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/permissions
