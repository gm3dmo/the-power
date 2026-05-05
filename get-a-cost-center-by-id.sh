.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/cost-centers?apiVersion=2026-03-10#get-a-cost-center-by-id
# GET /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}


# If the script is passed an argument $1 use that as the cost_center_id
if [ -z "$1" ]
  then
    cost_center_id=$(./get-all-cost-centers-for-an-enterprise.sh | jq -r '.costCenters[-1].id')
  else
    cost_center_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers/${cost_center_id}" 
