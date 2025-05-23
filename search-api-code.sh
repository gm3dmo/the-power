.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/search/search?apiVersion=2022-11-28#search-code
# GET /search/code


search_string="addClass"
language="js"

# The org and repo lines below implements the search in the documentation example above e.g. a search on JQuery. You can uncomment them to target the JQuery repo
#org="jquery"
repo="jquery"

search_query="${search_string}+in:file+language:${language}+repo:${org}/${repo}"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/search/code?q=${search_query}"


