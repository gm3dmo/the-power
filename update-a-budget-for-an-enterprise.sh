.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/budgets?apiVersion=2022-11-28#update-a-budget
# PATCH /enterprises/{enterprise}/settings/billing/budgets/{budget_id}

# Updates an existing budget for an enterprise. The authenticated user must be an
# enterprise admin, organization admin, or billing manager of the enterprise.

# If the script is passed an argument $1 use that as the budget_id
if [ -z "$1" ]
  then
    budget_id=${budget_id}
  else
    budget_id=$1
fi

# Budget settings to update (override by editing these values).
budget_amount=10
prevent_further_usage="false"
will_alert="false"

json_file=tmp/update-a-budget.json

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
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/budgets/${budget_id}" --data @${json_file}
