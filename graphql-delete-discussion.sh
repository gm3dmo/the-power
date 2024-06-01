. .gh-api-examples.conf

# Wrap a graphql script for use with curl


# Set the variables for the mutation
id=$1
clientMutationId=$2

graphql_query=tmp/graphql_query.txt

cat <<EOF >$graphql_query
mutation {
    deleteDiscussion(
        input: {
            id: "${id}",
            clientMutationId: "${clientMutationId}"
        }
    ) {
        clientMutationId
    }
}
EOF

json_file=tmp/graphql-delete-discussion.json

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d @${json_file} | jq

