.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api
# Demonstrates pagination for gh api

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -F owner="${org}" -F is_archived=false -f query='
query ($owner: String!, $after: String, $is_archived: Boolean!) {
      organization(login: $owner) {
        repositories(
          isArchived: $is_archived
          first: 100
          orderBy: {field: PUSHED_AT, direction: DESC}
          after: $after
        ) {
          nodes {
            name
            description
            url
            collaborators(first: 5, affiliation: ALL) {
              edges {
                permission
                node {
                  id
                  login
                  name
                  email
                }
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
            pushedAt
          }
          pageInfo {
            endCursor
            hasNextPage
          }
        }
      }
    }
' 

