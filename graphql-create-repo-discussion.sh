.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions

repository_id=$(./list-repo.sh | jq '.node_id')
category_id=$(./graphql-discussion-categories.sh | jq -r '.data.repository.discussionCategories.nodes[] | select(.name == "General") | .id')
ts=$(date +%s)
title="The Power Discussion ${ts}"

read -r -d '' graphql_script <<- EOF
mutation {
  createDiscussion(input: {repositoryId: $repository_id, categoryId: "$category_id", title: "$title", body: "The body", }) {
    discussion {
      id
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d "{ \"query\": \"$graphql_script\"}"

