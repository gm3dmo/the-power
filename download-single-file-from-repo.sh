.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-repository-content
# GET /repos/{owner}/{repo}/contents/{path}

filename_to_download="requirements.txt"
output_filename="requirements.downloaded.txt"

curl ${curl_custom_flags} \
     -H 'Accept: application/vnd.github.v3.raw' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_to_download} -o ${output_filename}
