. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#upload-a-release-asset
# POST /repos/{owner}/{repo}/releases/{release_id}/assets

response_file=tmp/response.json
response=$(curl -sH "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/latest > ${response_file})

release_id=$(cat $response_file | jq -r '.id')
upload_url=$(cat $response_file | jq -r '.upload_url')
clean_upload_url=${upload_url%?????????????}

upload_asset_filename=release-asset.gz

set -x
curl  -v \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/json"  \
      -H "Content-Type: binary" \
         "${clean_upload_url}?name=${upload_asset_filename}" --data-binary @${upload_asset_filename}

