.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-tree
# POST /repos/:owner/:repo/git/trees

# If the script is passed an argument $1 use that as the name for the repo
if [ -z "$1" ]
  then
    repo=${pre_receive_hook_repo}
  else
    repo=$1
fi

last_commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${base_branch} | jq -r '.commit.sha')
timestamp=$(date +%s)

content="echo \"This script is called by hook (${pre_receive_hook_name}) You can replace it with a more useful script\" ; exit 0"

json_file=tmp/pre-receive-hook-create-tree.json

jq -n \
        --arg base_tree "${last_commit_sha}" \
        --arg path "${pre_receive_hook_script}" \
        --arg content "${content}" \
'{ "base_tree" : $base_tree, "tree" : [ { "path": $path, "mode": "100755", type: "blob", content: $content }]}'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/trees --data @${json_file}
