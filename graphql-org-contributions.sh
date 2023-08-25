.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api
# Demonstrates pagination for gh api
# Demonstrates debug mode for gh tool

export GH_DEBUG="api gh pr list"

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -F owner="${org}" -f query='
query($owner: String!) {
  organization(login: $owner) {
    membersWithRole(first: 100) {
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
