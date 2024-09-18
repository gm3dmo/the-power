.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/billing?apiVersion=2022-11-28#get-github-advanced-security-active-committers-for-an-organization
# GET /orgs/{org}/settings/billing/advanced-security

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/settings/billing/advanced-security
