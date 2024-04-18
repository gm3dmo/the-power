.  ./.gh-api-examples.conf


export GH_TOKEN=${GITHUB_TOKEN}


gh api graphql --paginate -F org="${org}"  -f query='
query getRepos($org: String!) {
 organization(login: $org) {
    name
    repositories(first:10) {
        totalCount
        totalDiskUsage
    }
 }
}
'
