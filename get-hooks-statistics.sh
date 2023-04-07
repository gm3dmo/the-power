.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/enterprise-admin/admin-stats#get-hooks-statistics
# GET /enterprise/stats/hooks


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/enterprise/stats/hooks


