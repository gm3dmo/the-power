.  ./.gh-api-examples.conf

read -r -d '' graphql_script <<- EOF
{
  repository(owner: "$owner", name: "$repo") {
    pullRequests(first: 10) {
      edges {
        node {
          number
          title
          state
          createdAt
          updatedAt
          author {
            login
          }
          url
        }
      }
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

set -x
curl  -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
