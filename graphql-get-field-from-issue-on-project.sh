.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api


export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql  -F issue_number=1 -f name="${repo}" -f owner="${org}" -F query='
query($owner: String!, $name: String!, $issue_number: Int!) {
  repository(owner: $owner,  name: $name) {
    issue(number: $issue_number) {
      id
      title
      number
      projectItems(first: 100) {
        nodes {
          id
          project {
            id
            title
            fields(first: 100) {
              nodes {
                ... on ProjectV2SingleSelectField {
                  id
                  name
                  dataType
                  options {
                    id
                    name
                    nameHTML
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
' 
