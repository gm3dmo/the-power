. .gh-api-examples.conf

# https://cli.github.com/manual/gh_api
# pagination might be a little broken (_゜_゜_)

gh api graphql --paginate -F owner="${org}"  -f query='
query GetPRs($owner: String!, $endCursor: String) {
  organization(login: $owner) {
    repositories(first: 100) {
      nodes {
        name
				id
        pullRequests(first: 100, after:$endCursor, orderBy: {field: CREATED_AT, direction: DESC}, states: MERGED) {
          nodes {
            title
            headRefName
            bodyText
            additions
            deletions
            createdAt
            id
          }
        }
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
'
