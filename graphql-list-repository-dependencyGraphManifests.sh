.  ./.gh-api-examples.conf



read -r -d '' graphql_script <<- EOF
query {
  repository(owner: "$org", name: "$repo") {
    dependencyGraphManifests(first: 10) {
      totalCount
      nodes {
        id
        filename        
      }
      edges {
        node {
          blobPath
          dependencies {
            totalCount
            nodes {
              packageName
              requirements
              hasDependencies
              packageManager
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
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

