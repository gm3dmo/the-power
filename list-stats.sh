.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#get-statistics
# GET /enterprise/stats/{type}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprise/stats/all
