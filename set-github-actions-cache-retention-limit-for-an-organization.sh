.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/cache?apiVersion=2022-11-28#set-github-actions-cache-retention-limit-for-an-organization
# PUT /orgs/{org}/actions/cache/retention-limit

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

max_cache_retention_days=90

json_file=tmp/cache-retention-limit.json
jq -n \
           --argjson max_cache_retention_days "${max_cache_retention_days}" \
           '{
             "max_cache_retention_days" : $max_cache_retention_days
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/cache/retention-limit" --data @${json_file}
