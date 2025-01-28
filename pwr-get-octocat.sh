.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/meta?apiVersion=2022-11-28#get-octocat
# GET /octocat

# curl_custom_flags="--fail-with-body --no-progress-meter --write-out %output{tmp/a.json}%{json}%output{tmp/b.json}%{header_json}" 
curl_custom_flags="--fail-with-body --no-progress-meter"

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/octocat"

#jq -r '{
#    "num_certs": .num_certs,
#    "http_code": .http_code,
#    "time_total": .time_total,
#    "url": .url
#}' tmp/a.json
#
#jq -r '{
#    "date": .date[],
#    "content-type": ."content-type"[],
#    "x-github-request-id": ."x-github-request-id"[],
#    "x-ratelimit-limit": ."x-ratelimit-limit"[],
#    "x-ratelimit-resource": ."x-ratelimit-resource"[]
#}' tmp/b.json
