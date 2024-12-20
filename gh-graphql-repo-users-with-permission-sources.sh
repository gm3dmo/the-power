.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api
# Demonstrates pagination for gh api

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql -F owner="${org}" -F repo="${repo}" -f query='
query($owner: String!, $repo: String!) {
  repository(owner: $owner, name: $repo) {
    nameWithOwner
    visibility 
    updatedAt
    pushedAt
    archivedAt
    collaborators(first: 100) {
      edges {
        permission
        node {
          login
        }
        permissionSources {
          sourcePermission: permission
          source {
            ... on Team {
              permissionSource: __typename
              teamName: name
            }
            ... on Organization {
              permissionSource: __typename
              orgName: name
            }
            ... on Repository {
              permissionSource: __typename
              repoName: name
            }
          }
        }
      }
    }
  }
}
'
