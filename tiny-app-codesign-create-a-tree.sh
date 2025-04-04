.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-tree
# POST /repos/:owner/:repo/git/trees

# Demonstrates uploading 2 files using a Trees API

# Override the GITHUB_TOKEN in the .gh-api-examples.conf with one from a GitHub App:
GITHUB_TOKEN=$1
last_commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${base_branch} | jq -r '.commit.sha')
timestamp=$(date +%s)
json_file=tmp/tiny-app-code-sign-create-a-tree.json

content1="file1 in tree"
content2="file2 in tree"

json_file=tmp/create-a-tree-with-two-files.json
jq -n \
        --arg base_tree "${last_commit_sha}" \
        --arg path1 "file1.txt" \
        --arg content1 "${content1}" \
        --arg path2 "file2.txt" \
        --arg content2 "${content2}" \
'{
  "base_tree": $base_tree,
  "tree": [
    { "path": $path1, "mode": "100755", "type": "blob", "content": $content1 },
    { "path": $path2, "mode": "100755", "type": "blob", "content": $content2 }
  ]
}' > ${json_file}



curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/trees --data @${json_file}

