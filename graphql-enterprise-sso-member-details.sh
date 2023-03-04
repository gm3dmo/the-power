. .gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#enterpriseownerinfo


read -r -d '' graphql_script <<- EOF
{
  enterprise(slug: "$enterprise") {
    ownerInfo {
      samlIdentityProvider {
        externalIdentities(first: 100) {
          totalCount
          edges {
            node {
              guid
              samlIdentity {
                nameId
              }
              user {
                login
              }
            }
          }
          pageInfo {
            hasNextPage
	    endCursor
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
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
       ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}" | jq -r 