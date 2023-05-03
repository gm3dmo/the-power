.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/enterprise-admin/audit-log
# GET /enterprises/{enterprise}/audit-log

echo "No include (see documentation) only web will be delivered by default."

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log" | jq -r '.[0]'

echo "Only git events (push etc). What this returns should be a git.* event. See [git category actions](https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/audit-log-events-for-your-organization#git-category-actions)"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?include=git" | jq -r '.[0]'

