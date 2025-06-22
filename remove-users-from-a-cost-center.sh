.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/billing?apiVersion=2022-11-28#remove-users-from-a-cost-center
# DELETE /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource


cost_center_id=$(./get-all-cost-centers-for-an-enterprise.sh | jq -r '.costCenters[-1].id')
username_to_remove=$(./get-all-cost-centers-for-an-enterprise.sh | jq -r '.costCenters[].resources | map(select(.type=="User")) | .[-1].name')

json_file=tmp/remove-users-from-a-cost-center.json
jq -n \
           --arg users "$username_to_remove" \
           '{
             users :[ $users ],
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers/${cost_center_id}/resource"  --data @${json_file}

