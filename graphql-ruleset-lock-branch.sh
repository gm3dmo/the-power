.  ./.gh-api-examples.conf

repo_id=$(./list-repo.sh | jq -r '.node_id')

read -r -d '' graphql_script <<EOF
mutation {
  createRepositoryRuleset(
    input: {
      sourceId: "$repo_id",
      target: BRANCH,
      name: "Block all modification of the default branch",
      enforcement: ACTIVE,
      conditions: {
        refName: {
          include: ["~DEFAULT_BRANCH"],
          exclude: []
        }
      },
      rules: [
        { type: LOCK_BRANCH }
      ]
    }
  ) {
    ruleset { id }
  }
}
EOF

graphql_script_json=$(jq -Rs . <<< "$graphql_script")

curl ${curl_custom_flags} \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${GITHUB_APIV4_BASE_URL}" \
  -d "{ \"query\": $graphql_script_json }" | jq -r
