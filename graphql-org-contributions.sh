.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api
# Demonstrates pagination for gh api
# Demonstrates debug mode for gh tool

# export GH_DEBUG="api gh list"

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -F owner="${org}" -F first=3 -f query='
query($owner: String!, $first: Int!) {
  organization(login: $owner) {
    membersWithRole(first: $first) {
      nodes {
        login
        contributionsCollection {
          totalCommitContributions
          totalRepositoriesWithContributedCommits
          totalIssueContributions
          totalPullRequestContributions
          totalPullRequestReviewContributions
        }
    }
   }
  }
}
'
