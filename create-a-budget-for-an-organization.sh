.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/billing/budgets?apiVersion=2026-03-10#create-a-budget-for-an-organization
# POST /organizations/{org}/settings/billing/budgets

org=${1:-${org}}

# Budget settings (override by editing these values).
budget_amount=500
prevent_further_usage="true"
budget_scope="organization"
budget_entity_name=""
budget_type="ProductPricing"
budget_product_sku="actions"
will_alert="false"
user=""

json_file=tmp/create-a-budget-for-an-organization.json

jq -n \
           --argjson budget_amount "${budget_amount}" \
           --argjson prevent_further_usage "${prevent_further_usage}" \
           --arg budget_scope "${budget_scope}" \
           --arg budget_entity_name "${budget_entity_name}" \
           --arg budget_type "${budget_type}" \
           --arg budget_product_sku "${budget_product_sku}" \
           --argjson will_alert "${will_alert}" \
           --arg user "${user}" \
           '{
             budget_amount: $budget_amount,
             prevent_further_usage: $prevent_further_usage,
             budget_scope: $budget_scope,
             budget_entity_name: $budget_entity_name,
             budget_type: $budget_type,
             budget_product_sku: $budget_product_sku,
             budget_alerting: {
               will_alert: $will_alert,
               alert_recipients: []
             }
           } + if $budget_scope == "user" then {user: $user} else {} end' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/organizations/${org}/settings/billing/budgets" --data @${json_file}
