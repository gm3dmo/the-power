.  ./.gh-api-examples.conf

read -r -d '' graphql_script <<- EOF
{
  repository(owner: "$owner", name: "$repo") {
    pullRequest(number: 2) {
          number
          title
          state
          createdAt
          updatedAt
          author {
            login
          }
          baseRef {
            refUpdateRule {
              requiredStatusCheckContexts,
            }
    }
  }
 }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
