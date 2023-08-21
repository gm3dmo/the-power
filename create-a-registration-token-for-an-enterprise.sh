.  ./.gh-api-examples.conf

# https://docs.github.com/rest/reference/actions#create-a-registration-token-for-an-enterprise
# POST /enterprises/{enterprise}/actions/runners/registration-token

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/runners/registration-token
