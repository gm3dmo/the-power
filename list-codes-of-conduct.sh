.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/codes-of-conduct#get-all-codes-of-conduct
# GET /codes_of_conduct

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.scarlet-witch-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         ${GITHUB_API_BASE_URL}/codes_of_conduct
