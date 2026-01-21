.  ./.gh-api-examples.conf

# This script is from here.
# https://github.com/github/platform-samples/blob/master/graphql/queries/emu-scim-list-scim-identities.graphql
#

read -r -d '' graphql_script <<- 'EOF'
{
  enterprise(slug: "%s" ) {
    ownerInfo {
      samlIdentityProvider {
        externalIdentities(first: 100) {
          pageInfo {
            hasNextPage
            endCursor
          }
          edges{
            node{
              scimIdentity {
                username
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
  }
}
EOF

graphql_script=$(printf "$graphql_script" "$enterprise")
graphql_script=$(echo "$graphql_script" | tr -d '\n' | sed 's/"/\\"/g')

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

