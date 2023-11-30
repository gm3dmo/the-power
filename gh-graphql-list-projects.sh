.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}
export GH_ENTERPRISE_TOKEN=${GITHUB_TOKEN}
export GH_ENTERPRISE_TOKEN
export GH_HOST=${hostname}
export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -F owner="${org}"  -f query='
query($owner: String!) {
    organization(login: $owner) {
      projectsV2(first: 10) {
        nodes {
          id
          title
        }
      }
    }
}'
