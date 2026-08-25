.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/billing/budgets?apiVersion=2026-03-10#get-a-budget-by-id-for-an-organization
# GET /organizations/{org}/settings/billing/budgets/{budget_id}

org=${1:-${org}}
budget_id=${2:-${budget_id}}

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/organizations/${org}/settings/billing/budgets/${budget_id}"
