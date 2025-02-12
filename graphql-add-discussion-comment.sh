.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#adddiscussioncomment
# https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions


ts=$(date +%s)
repository_id=$(./list-repo.sh | jq '.node_id')
discussion_id=$(./graphql-list-repository-discussions.sh | jq '[.data.repository.discussions.nodes[].id] | max')

discussion_title="The Power Discussion ${ts} 💬"
discussion_comment_body="A discussion comment 🍇🦴"

set -x
read -r -d '' graphql_script <<- EOF
mutation {
    addDiscussionComment( input: {discussionId: $discussion_id, body: $discussion_comment_body }) { 
     comment {
              body 
     } 
}"
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d "{ \"query\": \"$graphql_script\"}"
