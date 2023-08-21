.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/codes-of-conduct#get-a-code-of-conduct
# GET /codes_of_conduct/{key}

name=${1:-contributor_covenant}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: Accept: application/vnd.github.scarlet-witch-preview+json" \
     -H "Accept: application/vnd.github.VERSION.raw" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/codes_of_conduct/${name}
