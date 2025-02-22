.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#adddiscussioncomment
# https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions


ts=$(date +%s)
repository_id=$(./list-repo.sh | jq '.node_id')
discussion_id="D_kwDON4cfxc4AeWL9"

discussion_title="The Power Discussion ${ts} 💬"
discussion_comment_body="A discussion comment 🍇🦴"

read -r -d '' graphql_script <<- EOF
mutation { addDiscussionComment(input: {discussionId: \"${discussion_id}\", body: \"${discussion_comment_body}\"}) { comment { id } } }
EOF

graphql_script="$(echo "${graphql_script}" | tr -d '\n' )"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     "${GITHUB_APIV4_BASE_URL}" -d "{ \"query\": \"$graphql_script\"}"
