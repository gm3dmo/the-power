.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-release-asset
# GET /repos/:owner/:repo/releases/assets/:asset_id

release_tarball_name=$(./list-releases.sh | jq -r '.[] | .tarball_url')

output_file=tmp/test.tar.gz

curl ${curl_custom_flags} \
     -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${release_tarball_name} --output ${output_file}
