.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-commit
# POST /repos/:owner/:repo/git/commits

GITHUB_TOKEN=$1
tree_sha=$(cat tmp/tiny-app-codesign-create-a-tree-response.json | jq -r '.sha')
json_file=tmp/tiny-app-codesign-create-commit.json
last_commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${base_branch} | jq -r '.commit.sha')


jq -n \
                --arg message  "github app codesign ${RANDOM}" \
                --arg tree_sha "${tree_sha}" \
                --arg last_commit_sha "${last_commit_sha}" \
                      '{message: $message, "parents": [ $last_commit_sha ], "tree": $tree_sha   }'  > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/commits --data @${json_file}
