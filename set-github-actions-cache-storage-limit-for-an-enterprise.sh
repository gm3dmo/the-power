.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/cache?apiVersion=2022-11-28#set-github-actions-cache-storage-limit-for-an-enterprise
# PUT /enterprises/{enterprise}/actions/cache/storage-limit

max_cache_size_gb=10

json_file=tmp/cache-storage-limit.json
jq -n \
           --argjson max_cache_size_gb "${max_cache_size_gb}" \
           '{
             "max_cache_size_gb" : $max_cache_size_gb
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/cache/storage-limit" --data @${json_file}
