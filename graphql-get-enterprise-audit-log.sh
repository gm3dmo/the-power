.  ./.gh-api-examples.conf

# lists audit log entries for all organizaitons under the Enterprise account
# https://docs.github.com/en/graphql/reference/objects#organization


read -r -d '' graphql_script <<- EOF
{
  enterprise(slug: "$enterprise") {
    organizations(first: 100) {
      nodes {
        auditLog(last: 5) {
          edges {
            node {
              ... on AuditEntry {
                action
                actorLogin
                createdAt
              }
            }
          }
        }
      }
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
       ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}" | jq -r