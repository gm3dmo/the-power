.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

python3 create-commit-python-pip.py

filename_in_repo="requirements.txt"
  json_file=tmp/requirements.json
  curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
