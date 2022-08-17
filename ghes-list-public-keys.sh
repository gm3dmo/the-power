. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.4/rest/reference/enterprise-admin#list-public-keys
# GET /admin/keys

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/keys
