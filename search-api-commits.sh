.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/search#search-commits 
# GET /search/commits

search_string="future"

# The org and repo lines below implements the search in the documentation example:
org="octocat"
repo="Spoon-Knife"

search_query="repo:${org}/${repo}+${search_string}"

echo "This doesn't seem to return anything in the example docs e.g. no resuls for css in the spoon knife repo."

set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.cloak-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/search/commits?q=${search_query}"
