.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-release
# GET /repos/{owner}/{repo}/releases/{release_id}

response_file="tmp/latest-release.json"
$(curl ${curl_custom_flags} -sH "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/latest > ${response_file})


tarball_url=$(cat "$response_file" | jq -r '.tarball_url')
zipball_url=$(cat "$response_file" | jq -r '.zipball_url')
tag_name=$(cat "$response_file" | jq -r '.tag_name')

download_url=$tarball_url

set -x
curl ${curl_custom_flags} \
     -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/octet-stream" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${download_url}" -o "tmp/${repo}.release_${tag_name}"


ls -l tmp/${repo}.release_${tag_name}
