.  ./.gh-api-examples.conf


# https://docs.github.com/en/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#list-fine-grained-personal-access-tokens-with-access-to-organization-resources
# GET /orgs/{org}/personal-access-tokens


./ent-pwr-list-app-installations.sh > tmp/orgs_installed_on.json

arrs=$(jq -s . tmp/orgs_installed_on.json)
for i in $(echo "$arrs" | jq -r 'to_entries[] | .key'); do
  org=$(echo "$arrs" | jq -r ".[$i][0]")
  installation_id=$(echo "$arrs" | jq -r ".[$i][1]")
  echo "org: $org" >&2
  echo "installation_id: $installation_id" >&2
  GITHUB_TOKEN=$(./ent-call-get-installation-token.sh "$installation_id" | jq -r '.token')
  curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     "${GITHUB_API_BASE_URL}/orgs/${org}/personal-access-tokens?per_page=100" > tmp/fg-pat-report-$org.json
done


 jq -s 'add' tmp/fg-pat-report-*.json > tmp/fg-pat-report.json


jq -r '["token_name","token_id","token_expired","token_expires_at","token_last_used_at"], 
       ( .[] | [ .token_name, .token_id, .token_expired, .token_expires_at, .token_last_used_at ] ) 
       | @csv' tmp/fg-pat-report.json 