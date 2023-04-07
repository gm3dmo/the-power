.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

filepath="docs/README.md"

read -r -d '' graphql_script <<- EOF
{
  repository(name: "$repo", owner: "$org") {
    object(expression: "$base_branch") {
      ... on Commit {
        history(path: "$filepath", first: 10) {
          nodes {
            author {
              email
              user {
                login
              }
            }
            messageHeadline
            oid
            committedDate
          }
        }
      }
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

set -x

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

