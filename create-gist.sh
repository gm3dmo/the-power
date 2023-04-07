.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/gists#create-a-gist
# POST /gists

json_file=test-data/gist.json

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/gists --data @${json_file}
