. .gh-api-examples.conf

repo_node_id="MDEwOlJlcG9zaXRvcnkx"


owner_id=$(bash ./list-repo.sh | jq -r '.node_id')

graphql_query=tmp/graphql_query.txt
rm -f ${graphql_query}

cat <<EOF >$graphql_query
mutation CreateIssue {
  createIssue(input: {repositoryId: "$repo_node_id", title: "TestIssue", body: "TEST issue"}) {
    issue {
      number
      body
    }
  }
}
EOF

json_file=tmp/graphql-payload.json
rm -f ${json_file}

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

rm -f ${graphql_query}
rm -f ${json_file}
