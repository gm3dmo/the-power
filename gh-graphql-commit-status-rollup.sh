.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

# https://dev.to/gr2m/github-api-how-to-retrieve-the-combined-pull-request-status-from-commit-statuses-check-runs-and-github-action-results-2cen

export GH_TOKEN=${GITHUB_TOKEN}

commit_depth=1

gh api graphql --paginate -F owner="${owner}" -f repo="${repo}" -F pull_number=${default_pull_request_id} -F commit_depth=${commit_depth} -f query='
query($owner: String!, $repo: String!, $pull_number: Int!, $commit_depth: Int!) {
  repository(owner: $owner, name:$repo) {
    pullRequest(number:$pull_number) {
      id
      commits(last: $commit_depth) {
        nodes {
          commit {
            id
            statusCheckRollup {
              state
            }
          }
        }
      }
    }
  }
}

'


