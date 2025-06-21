.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/billing?apiVersion=2022-11-28#add-users-to-a-cost-center
# POST /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource




# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    cost_center_id=$(./get-all-cost-centers-for-an-enterprise.sh | jq -r '.costCenters[-1].id')
  else
    cost_center_id=$1
fi

users="[$(printf '"%s"' "$default_committer")]"

json_file=tmp/add-users-to-a-cost-center.json
jq -n \
           --argjson users "${users}" \
           '{
             users :  $users 
           }' > ${json_file}

cat $json_file | jq -r >&2

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers/${cost_center_id}/resource"  --data @${json_file}

