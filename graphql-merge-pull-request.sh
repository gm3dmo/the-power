.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#mergepullrequest

pull_request_id=$1
email_address=test@example.com
commit_headline="this is the commit_headline"

graphql_query=tmp/graphql_query.txt

cat <<EOF >$graphql_query
mutation {
    mergePullRequest(
        input: {
            authorEmail: "${email_address}"
            commitHeadline: "${commit_headline}",
            mergeMethod:SQUASH,
            pullRequestId: "${pull_request_id}"
        }
    ) {
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
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

