.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}
export GH_ENTERPRISE_TOKEN=${GITHUB_TOKEN}
#export GH_HOST=${hostname}

export GH_DEBUG="api gh pr list"

gh api graphql --paginate -F owner="${owner}"  -f query='
query($owner: String! ) {
    organization(login: $owner) {
      repositories {
      totalCount
      }
    }
}'
