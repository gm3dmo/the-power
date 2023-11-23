.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/copilot/copilot-for-business?apiVersion=2022-11-28#list-all-copilot-for-business-seat-assignments-for-an-organization
# GET /orgs/{org}/copilot/billing/seats

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/copilot/billing/seats"
