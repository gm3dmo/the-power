.  ./.gh-api-examples.conf

## https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -F owner="${org}"  -f query='
query($owner: String!, $endCursor: String, $issueCursor: String) {
  organization(login: $owner) {
    repositories(first: 5, after: $endCursor) {
      nodes {
        name
        databaseId
        id
        owner {
         login
        }
        issues(first: 5, after: $issueCursor) {
           nodes {
             number
             title
        }
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
