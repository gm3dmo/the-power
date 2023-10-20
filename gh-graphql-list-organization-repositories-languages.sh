.  ./.gh-api-examples.conf

export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -f owner="${owner}" -f repo="${repo}" -F pull_number=${default_pull_request_id} -F commit_depth=${commit_depth} -f query='
query($owner: String!) {
  organization(login: $owner) {
    name
    repositories(first: 30) {
        nodes {
            name
            description
            url
            createdAt
            updatedAt
            pushedAt
            primaryLanguage {
                name
           }
           languages(first: 100) {
               nodes {
                      name
               }
           }
       }
  }
}
}
'
