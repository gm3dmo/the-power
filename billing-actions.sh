.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/billing#get-github-actions-billing-for-an-organization
# GET /orgs/{org}/settings/billing/actions

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/settings/billing/actions
