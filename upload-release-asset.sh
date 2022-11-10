. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#upload-a-release-asset
# POST /repos/{owner}/{repo}/releases/{release_id}/assets
#
#
# Caveat:
# The value:
# "upload_url": "https://uploads.github.com/repos/octocat/Hello-World/releases/1/assets{?name,label}" 
# seems like it could be clearer.


response_file=tmp/response.json
response=$(curl -sH "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/latest > ${response_file})

release_id=$(cat $response_file | jq -r '.id')
upload_url=$(cat $response_file | jq -r '.upload_url')
clean_upload_url=${upload_url%?????????????}

set -x
timestamp=$(date +%s)
upload_asset_filename=test-data/release-asset.gz
upload_asset_filename_b=release-asset-${timestamp}.gz

curl  -v \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/json"  \
      -H "Content-Type: binary" \
         "${clean_upload_url}?name=${upload_asset_filename_b}" --data-binary @${upload_asset_filename}

