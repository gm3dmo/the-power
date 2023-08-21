.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/search#search-repositories
# GET /search/repositories

search_target=repositories
date_for_search="2021-01-31"
visibility="internal"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/search/${search_target}?q=created:>${date_for_search}+fork:true+is:${visibility}" | jq -r '"\(.total_count),\(.incomplete_results)"'
