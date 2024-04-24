.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}

branch=new_branch

gh api graphql --paginate -F owner="${owner}" -f repo="${repo}" -F branch="${branch}" -f query='
query($owner: String!,  $repo: String!, $branch: String! ) {
  repository(owner: $owner name: $repo) {
    name
    object(expression: $branch) {
      ... on Commit {
        history {
          totalCount
        }
      }
    }
  }
}
'
