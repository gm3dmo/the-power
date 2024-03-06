.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/markdown/markdown?apiVersion=2022-11-28#render-a-markdown-document
# POST /markdown


json_file=tmp/render-a-markdown-document.json

jq -n \
           --arg text "hello **world**" \
           '{
             text: $text,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/markdown"  --data @${json_file}
