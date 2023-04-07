.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-release
# GET /repos/{owner}/{repo}/releases/{release_id}

org=actions
repo=runner
response=$(curl ${curl_custom_flags} -sH "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/latest | jq -r '.body')

echo $response > tmp/response

platform=osx
cpu=x86

curl_commands=$(perl -ne 'printf "$1$2\n" if m/(curl -O -L https:)(.*.gz)/' tmp/response)

echo $curl_commands

exit

tarball_url=$(echo "$response" | jq -r '.tarball_url')
zipball_url=$(echo "$response" | jq -r '.zipball_url')
tag_name=$(echo "$response" | jq -r '.tag_name')

download_url=$tarball_url

curl ${curl_custom_flags} \
     -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/octet-stream" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${download_url}" -o "tmp/${repo}.release_${tag_name}"
