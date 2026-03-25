.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/cost-centers?apiVersion=2026-03-10#add-resources-to-a-cost-center
# POST /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource

json_file=tmp/add-resources-to-a-cost-center.json



jq -n \
           --arg name "${owner}/${repo}" \
           '{
            repositories : [ $name ]
           }' > ${json_file}


cat $json_file |  jq -r

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers/${cost_center_id}/resource"  --data @${json_file}

