.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -F owner="${org}"  -f query='
query($owner: String!, $cursor: String) {
    organization(login: $owner) {
      projectsV2(first: 10, after: $cursor) {
        nodes {
          id
          title
          createdAt
          updatedAt 
        }
        pageInfo {
          endCursor
          hasNextPage
       }
      }
    }
}'
