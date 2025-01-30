.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/codes-of-conduct/codes-of-conduct?apiVersion=2022-11-28#get-all-codes-of-conduct
# GET /codes_of_conduct


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         "${GITHUB_API_BASE_URL}/codes_of_conduct"

