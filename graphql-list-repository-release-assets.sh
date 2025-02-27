.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/graphql/reference/objects#releaseasset
# https://docs.github.com/en/enterprise-cloud@latest/graphql/reference/objects#release

# Copilot generated this script in a few seconds.

read -r -d '' graphql_script <<- EOF
{
search(type: REPOSITORY, query: "repo:$org/$repo", first: 1) {
    nodes {
      ... on Repository {
        id
        databaseId
        nameWithOwner
        createdAt
        isSecurityPolicyEnabled
        isArchived
        rulesets(first: 10) {
          totalCount
          nodes {
            name
            target
            enforcement
          }
        }
        releases(last: 1) {
          totalCount
          nodes {
            tagName
            releaseAssets(first: 100) {
              totalCount
              nodes {
                name
                size
                createdAt
                updatedAt
                downloadUrl
                contentType
                downloadCount
                uploadedBy { name }
              }
            }
          }
        }
      }
    }
  }
}
EOF

graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
