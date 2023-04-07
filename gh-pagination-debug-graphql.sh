.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api
# Demonstrates pagination for gh api
# Demonstrates debug mode for gh tool

export GH_DEBUG="api gh pr list"

gh api graphql --paginate -F owner="${org}"  -f query='
query($owner: String!, $endCursor: String) {
  organization(login: $owner) {
    repositories(first: 50, after: $endCursor) {
      nodes {
        name
        databaseId
        id
        owner {
         login
        }
      }
      pageInfo {
        endCursor
        hasNextPage
      }
    }
  }
}
'
