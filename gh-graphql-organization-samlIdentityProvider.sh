.  ./.gh-api-examples.conf

# 


gh api graphql --paginate -F owner="${org}"  -f query='
query($owner: String!)  {
  organization(login: $owner) {
    samlIdentityProvider {
      externalIdentities(first: 100) {
      	nodes {
          samlIdentity {
            nameId
          }
          scimIdentity {
            familyName
            givenName
          }
          user {
            login
            name
          }
        }
      }
    }
  }
}
'
