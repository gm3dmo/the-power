.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/reference/actions#create-a-registration-token-for-a-repository
# POST /repos/{owner}/{repo}/actions/runners/registration-token

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/runners/registration-token
