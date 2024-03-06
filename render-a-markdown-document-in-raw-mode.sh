.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/markdown/markdown?apiVersion=2022-11-28#render-a-markdown-document-in-raw-mode
# POST /markdown/raw

json_file=tmp/render-a-markdown-document-in-raw-mode.json


curl ${curl_custom_flags} \
     -H "Content-Type: text/plain" \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/markdown/raw"  --data "hello **world**"
