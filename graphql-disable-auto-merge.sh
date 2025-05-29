.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#disablepullrequestautomerge


if [ -z "$1" ]
  then
    pull_request_node_id=$(./list-pull-request.sh | jq -r '.node_id')
  else
    pull_request_node_id=$1
fi


graphql_query=tmp/graphql-enable-pull-request-auto-merge.txt

cat <<EOF >$graphql_query
mutation automerge {
    disablePullRequestAutoMerge(input: {pullRequestId: "$pull_request_node_id" }) {
        clientMutationId
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
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

