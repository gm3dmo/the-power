.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    branch=$branch_name
  else
    branch=$1
fi

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
