.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.15/rest/enterprise-admin/users?apiVersion=2022-11-28#list-public-keys
# GET /admin/keys


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/admin/keys"

