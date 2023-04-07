.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/rate-limit 
# GET /rate_limit
 
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/rate_limit


