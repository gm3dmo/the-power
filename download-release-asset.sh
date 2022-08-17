. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-release-asset
# GET /repos/{owner}/{repo}/releases/assets/{asset_id}

response=$(curl -sH "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/latest)

asset_id=$(echo "$response" | jq -r '.assets[0] .id')
asset_name=$(echo "$response" | jq -r '.assets[0] .name')

curl ${curl_custom_flags} \
     -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/octet-stream" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/assets/${asset_id}" -o "tmp/${asset_name}.downloaded"
