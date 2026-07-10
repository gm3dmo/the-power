.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/budgets?apiVersion=2022-11-28#delete-a-budget
# DELETE /enterprises/{enterprise}/settings/billing/budgets/{budget_id}

# Deletes a budget by ID. The authenticated user must be an enterprise admin.

# If the script is passed an argument $1 use that as the budget_id
if [ -z "$1" ]
  then
    budget_id=${budget_id}
  else
    budget_id=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/budgets/${budget_id}"
