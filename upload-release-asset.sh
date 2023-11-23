.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/releases/assets?apiVersion=2022-11-28#update-a-release-asset
# POST /repos/{owner}/{repo}/releases/{release_id}/assets
#
# Credit to:
# https://stackoverflow.com/questions/9973056/curl-how-to-display-progress-information-while-uploading
# and:
# https://stackoverflow.com/questions/51222398/using-curl-data-binary-option-out-of-memory
#
# Caveat:
# The value:
# "upload_url": "https://uploads.github.com/repos/octocat/Hello-World/releases/1/assets{?name,label}" 
# seems like it could be clearer in the docs that you can't actually use that
# as is in the form that the API returns it. This script handles that by creating the `clean_upload_url` by chopping of the last 12 characters.


response_file=tmp/response.json
response=$(curl -sH "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/latest > ${response_file})

release_id=$(cat $response_file | jq -r '.id')
upload_url=$(cat $response_file | jq -r '.upload_url')
clean_upload_url=${upload_url%?????????????}

timestamp=$(date +%s)
upload_asset_filename=test-data/release-asset.gz
upload_asset_filename_b=release-asset-${timestamp}.gz



curl \
     --progress-meter \
      -o tmp/upload.txt \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      -H "Accept: application/json"  \
      -H "Content-Type: binary" \
         "${clean_upload_url}?name=${upload_asset_filename_b}" --upload-file ${upload_asset_filename}

