.  ./.gh-api-examples.conf

# 
# 


curl --no-progress-meter -L -w '%{json}'   ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/status" | jq -r
