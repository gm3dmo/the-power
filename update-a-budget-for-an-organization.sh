.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/billing/budgets?apiVersion=2026-03-10#update-a-budget-for-an-organization
# PATCH /organizations/{org}/settings/billing/budgets/{budget_id}

org=${1:-${org}}
budget_id=${2:-${budget_id}}

# Budget settings to update (override by editing these values).
budget_amount=10
prevent_further_usage="false"
will_alert="false"

json_file=tmp/update-a-budget-for-an-organization.json

jq -n \
           --argjson budget_amount "${budget_amount}" \
           --argjson prevent_further_usage "${prevent_further_usage}" \
           --argjson will_alert "${will_alert}" \
           '{
             budget_amount: $budget_amount,
             prevent_further_usage: $prevent_further_usage,
             budget_alerting: {
               will_alert: $will_alert,
               alert_recipients: []
             }
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/organizations/${org}/settings/billing/budgets/${budget_id}" --data @${json_file}
