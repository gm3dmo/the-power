. .gh-api-examples.conf

gh api graphql --paginate -F owner="${org}"  -f query='
query($owner: String!, $endCursor: String) {
  organization(login: $owner) {
    repositories(first: 5, after: $endCursor) {
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
}'
