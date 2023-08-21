.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#repository

read -r -d '' graphql_script <<- EOF
{
search(type: REPOSITORY, query: "repo:$org/$repo", first: 100) {
    nodes {
      ... on Repository {
        id
        databaseId
        nameWithOwner
        createdAt
        isSecurityPolicyEnabled
        isArchived
        repositoryTopics(first: 100) {
          totalCount
          nodes {
            topic {
              name
            }
          }
        }
        openIssueCount: issues(states: [OPEN]) {
          totalCount
        }
        closedIssueCount: issues(states: [CLOSED]) {
          totalCount
        }
        releases(last: 1) {
          totalCount
          nodes {
            tagName
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
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

