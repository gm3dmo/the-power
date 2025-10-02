.  ./.gh-api-examples.conf

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo_node_id=$(bash ./list-repo.sh | jq -r '.node_id')
  else
    repo_node_id=$1
fi

ts=$(date +%s)

# This will get you the node id
graphql_query=tmp/graphql_query.txt

cat <<EOF >$graphql_query
mutation CreateIssue {
  createIssue(input: {repositoryId: "$repo_node_id", title: "The Power Test Issue (${ts})", body: "The Power test issue (${ts}) created by [graphql-create-issue.sh](https://github.com/gm3dmo/the-power/blob/main/graphql-create-issue.sh)"}) {
    issue {
      number
      body
    }
  }
}
EOF

json_file=tmp/graphql-payload.json
jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d @${json_file} | jq

