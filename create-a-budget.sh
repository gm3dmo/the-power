.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/budgets?apiVersion=2022-11-28#create-a-budget
# POST /enterprises/{enterprise}/settings/billing/budgets

# Creates a new budget for an enterprise. The authenticated user must be an
# enterprise admin, organization admin, or billing manager of the enterprise.

# Budget settings (override by editing these values).
budget_amount=200
prevent_further_usage="true"
budget_scope="enterprise"
budget_entity_name=""
budget_type="ProductPricing"
budget_product_sku="actions"
will_alert="false"

json_file=tmp/create-a-budget.json

jq -n \
           --argjson budget_amount "${budget_amount}" \
           --argjson prevent_further_usage "${prevent_further_usage}" \
           --arg budget_scope "${budget_scope}" \
           --arg budget_entity_name "${budget_entity_name}" \
           --arg budget_type "${budget_type}" \
           --arg budget_product_sku "${budget_product_sku}" \
           --argjson will_alert "${will_alert}" \
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
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/budgets" --data @${json_file}
