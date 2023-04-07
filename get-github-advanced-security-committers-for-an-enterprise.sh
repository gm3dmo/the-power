.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/billing#get-github-advanced-security-active-committers-for-an-enterprise
# GET /enterprises/{enterprise}/settings/billing/advanced-security

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/advanced-security
