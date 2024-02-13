.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path
#

blob_sha=$(curl --silent -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/docs/README.md?ref=new_branch" | jq -r '.sha')


python3 create-commit-update-readme.py --blob-sha ${blob_sha}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/docs/README.md --data @tmp/create-commit-update-readme.json
