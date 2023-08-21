.  ./.gh-api-examples.conf

response_file="tmp/runner-latest-release.json"
$(curl ${curl_custom_flags} -sH "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/actions/runner/releases/latest > ${response_file})
tag_name=$(cat "$response_file" | jq -r '.tag_name')
echo ${tag_name}
