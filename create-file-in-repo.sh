.  ./.gh-api-examples.conf

set -x
# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

for r in "repo-a" "repo-b" "repo-c" "repo-d"
do
repo=$r

filename_in_repo="docs/README.md"
json_file_to_upload="tmp/create-commit-readme.json"

contents_path="contents/${filename_in_repo}"


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/${contents_path} --data @${json_file_to_upload}
done
