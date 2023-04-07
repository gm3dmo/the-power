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

base_tree=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${base_branch} | jq -r '.object.sha')
timestamp=$(date +%s)


content="lorem ipsum"

json_file=tmp/create-tree.json
rm -f ${json_file}

jq -n \
        --arg base_tree "${base_tree}" \
        --arg path "pre-commit-hook.sh" \
        --arg content "${content}" \
        --arg sha "${sha}" \
'{ "base_tree" : $base_tree, "tree" : [ { "path": $path, "mode": "100755", type: "blob", content: $content }]}'  > ${json_file}

cat $json_file | jq -r
exit

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/trees --data @${json_file}

rm -f ${json_file}
