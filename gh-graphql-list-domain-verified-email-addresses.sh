.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#ipallowlistentry

enterprise=${1:-$enterprise}


export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -f organization="${org}" -F query='
query($organization: String!, $endCursor: String)  {
 organization(login: $organization ){
    membersWithRole(first:100, after: $endCursor){
      nodes{
            login
            organizationVerifiedDomainEmails(login:$organization)
      }
      pageInfo {
               endCursor
               hasNextPage
              }
   }
  }
}'
