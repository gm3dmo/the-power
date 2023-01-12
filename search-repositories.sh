. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/search?apiVersion=2022-11-28#search-repositories
# https://api.github.com/search/repositories?q=Q

# Pass query as an argument, otherwise list all repos with commits since 1st of Jan 2023
if [ -z "$1" ]
  then
    query="pushed:>2023-01-01"
  else
    query="$1"
fi

curl ${curl_custom_flags} \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  ${GITHUB_API_BASE_URL}/search/repositories?q=${query}
