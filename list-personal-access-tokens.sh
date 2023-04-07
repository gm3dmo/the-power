.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.0/rest/reference/enterprise-admin#list-personal-access-tokens
# GET /admin/tokens

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/tokens
