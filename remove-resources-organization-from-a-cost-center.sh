.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/cost-centers?apiVersion=2026-03-10#remove-resources-from-a-cost-center
# DELETE /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource


cost_center_id=$(./get-all-cost-centers-for-an-enterprise.sh | jq -r '.costCenters[-1].id')

json_file=tmp/remove-resources-organization-from-a-cost-center.json

jq -n \
           --arg name "${org}" \
           '{
            organizations : [ $name ]
           }' > ${json_file}


cat $json_file | jq -r

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers/${cost_center_id}/resource"  --data @${json_file}
