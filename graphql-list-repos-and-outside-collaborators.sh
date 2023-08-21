.  ./.gh-api-examples.conf

# lists repos and outside collabortors, including assosiated permissions
# https://docs.github.com/en/graphql/reference/objects#repository


read -r -d '' graphql_script <<- EOF
{
  organization(login: "${org}") {
    repositories(first: 100) {
      nodes {
        name
        collaborators(affiliation: OUTSIDE) {
          totalCount
          edges {
            permission
            node {
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
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
       ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
