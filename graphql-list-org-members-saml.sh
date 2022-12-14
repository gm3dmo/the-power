. .gh-api-examples.conf

# Use the external IDP to get information about the orgs users
# The flag membersOnly: true will dismiss members that are only present in the IDP, but not in the GitHub org


read -r -d '' graphql_script <<- EOF
{
  organization(login: "$org") {
    samlIdentityProvider {
      externalIdentities(first: 100, membersOnly: true) {
        pageInfo {
          endCursor
          startCursor
          hasNextPage
        }
        edges {
          cursor
          node {
            samlIdentity {
              nameId
            }
            user {
              login
            }
          }
        }
      }
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
