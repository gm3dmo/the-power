.  ./.gh-api-examples.conf

# https://github.blog/changelog/2020-05-19-api-support-for-viewing-organization-members-verified-email-addresses/

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
