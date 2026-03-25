.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/billing/cost-centers?apiVersion=2026-03-10#create-a-new-cost-center
# POST /enterprises/{enterprise}/settings/billing/cost-centers


json_file=tmp/create-a-new-cost-center.json

jq -n \
           --arg name "${cost_center_name}" \
           '{
             name : $name,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers"  --data @${json_file}

