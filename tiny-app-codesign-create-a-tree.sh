.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-tree
# POST /repos/:owner/:repo/git/trees


# Override the GITHUB_TOKEN in the .gh-api-examples.conf with one from a GitHub App:
GITHUB_TOKEN=$1
last_commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${base_branch} | jq -r '.commit.sha')
timestamp=$(date +%s)
json_file=tmp/tiny-app-code-sign-create-a-tree.json
content="This is content added by the tiny-app-code-signing demo."


jq -n \
        --arg base_tree "${last_commit_sha}" \
        --arg content "$content" \
        --arg path "github-app-codesign/test.txt" \
'{ "base_tree" : $base_tree, "tree" : [ { "path": $path, "mode": "100755", type: "blob", content: $content }]}'  > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/trees --data @${json_file}
