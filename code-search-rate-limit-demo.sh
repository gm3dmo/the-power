.  ./.gh-api-examples.conf

# 
# https://docs.github.com/en/enterprise-cloud@latest/rest/search?apiVersion=2022-11-28#rate-limit
# https://api.github.com/search/repositories?q=Q

# WORKS ON A MAC
default_start_date="$(date -v -7d +'%Y-%m-%d')"

# Pass query as an argument, otherwise list all repos with commits in the last seven days
if [ -z "$1" ]
  then
    query="addClass+in:file+language:js+repo:jquery/jquery"
  else
    query="$1"
fi

# Rate limit for code search is 10 (2024-09)
for n in {1..11}
do
echo "position in loop ${n}"
# verbose curl but no output from the curl, since it is not interesting for rate limit demo purposes
curl -v ${curl_custom_flags} \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  ${GITHUB_API_BASE_URL}/search/code?q=${query} > /dev/null
done
