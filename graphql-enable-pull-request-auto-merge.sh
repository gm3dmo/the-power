.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#createipallowlistentry



if [ -z "$1" ]
  then
   pull_request_id=2
  else
    pull_request_id=${default_pull_request_id}
fi

pull_request_id_graphql=$(./graphql-get-pull-request-id.sh ${pull_request_id} | jq -r '.data.repository.pullRequest.id')

graphql_query=tmp/graphql_query.txt
cat <<EOF >$graphql_query
mutation {
    enablePullRequestAutoMerge(input: {pullRequestId: "$pull_request_id_graphql", mergeMethod: MERGE}) {
        clientMutationId
         }
}
EOF

json_file=tmp/graphql-enable-pull-request-auto-merge.json
jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}



curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d @${json_file} | jq
