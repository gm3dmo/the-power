.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#commit
# GraphQL script to list commit stats for a branch for org repos using the Search API.
# If $1 is passed use that as the timestamp to search for commits after.

if [ -z "$1" ]
  then
    date=$(date +"%Y-%m-%d")
  else
    date=$1
fi

read -r -d '' graphql_script <<- EOF
{
  search(query: "org:${org}", type: REPOSITORY, first: 5) {
    repositoryCount
    edges {
      node {
        ... on Repository {
          nameWithOwner
          object(expression: "${base_branch}") {
            ... on Commit {
              history(since: "${date}T00:00:00") {
                totalCount
              }
            }
          }
        }
      }
    }
    pageInfo {
      endCursor
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
