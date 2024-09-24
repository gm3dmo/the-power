.  ./.gh-api-examples.conf

# 
# https://docs.github.com/en/enterprise-cloud@latest/rest/search?apiVersion=2022-11-28#rate-limit
# https://api.github.com/search/repositories?q=Q


# Pass query as an argument, otherwise list all repos with commits in the last seven days
if [ -z "$1" ]
  then
    query="addClass+in:file+language:js+repo:jquery/jquery"
  else
    query="$1"
fi


curl_custom_flags="--write-out %output{tmp/headers.json}%{header_json} --fail-with-body --silent "


# Rate limit for code search is 10 (2024-09)
sleep_period=7
for n in {1..11}
do
# verbose curl but no output from the curl, since it is not interesting for rate limit demo purposes
curl ${curl_custom_flags} \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  ${GITHUB_API_BASE_URL}/search/code?q=${query} > /dev/null

  results=$(cat tmp/headers.json | jq -r --arg n "$n" '"position in loop: \($n)\ndate: \(.date[0])\nx-ratelimit-limit: \(.["x-ratelimit-limit"][0])\nx-rate-limit-remaining: \(.["x-ratelimit-remaining"][0])\nx-github-request-id: \(.["x-github-request-id"][0])"')
  echo " " ${results}

  sleep ${sleep_period}
done

