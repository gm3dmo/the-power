.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@2.20/rest/reference/licenses#get-all-commonly-used-licenses
# GET /licenses

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/licenses
