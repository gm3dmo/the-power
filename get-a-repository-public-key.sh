.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#get-a-repository-public-key
# GET /repos/{owner}/{repo}/actions/secrets/public-key

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/secrets/public-key"
