.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/budgets?apiVersion=2022-11-28#get-all-budgets
# GET /enterprises/{enterprise}/settings/billing/budgets

# Gets all budgets for an enterprise. The authenticated user must be an
# enterprise admin or billing manager.

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/budgets"
