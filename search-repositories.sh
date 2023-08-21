.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/search?apiVersion=2022-11-28#search-repositories
# https://api.github.com/search/repositories?q=Q

# WORKS ON A MAC
default_start_date="$(date -v -7d +'%Y-%m-%d')"

# Pass query as an argument, otherwise list all repos with commits in the last seven days
if [ -z "$1" ]
  then
    query="pushed:>$default_start_date"
  else
    query="$1"
fi

curl ${curl_custom_flags} \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     "${GITHUB_API_BASE_URL}/search/repositories?q=${query}"
