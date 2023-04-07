.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/enterprise-admin/audit-log
# GET /enterprises/{enterprise}/audit-log

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log
