.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#ipallowlistentry

enterprise=${1:-$enterprise}

export GH_TOKEN=${GITHUB_TOKEN}

# You may well want to us something different than "first:2" here we use
# it to demonstrate pagination when using only a small number of users.

gh api graphql --paginate -f organization="${org}" -F query='
query($organization: String!, $endCursor: String)  {
 organization(login: $organization ){
    membersWithRole(first:2, after: $endCursor){
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
