.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/search?apiVersion=2022-11-28#search-issues-and-pull-requests
# https://api.github.com/search/issues?q=Q

# Pass query as an argument, otherwise list all open issues in your org
if [ -z "$1" ]
  then
    query="is:issue+state:open+org:${org}"
  else
    query="$1"
fi

curl ${curl_custom_flags} \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  ${GITHUB_API_BASE_URL}/search/issues?q=${query}
