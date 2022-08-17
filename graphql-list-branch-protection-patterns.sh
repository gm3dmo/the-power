. .gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

read -r -d '' graphql_script <<- EOF
{  repository(name:"$repo", owner:"$org") {
    branchProtectionRules(first:10){
      nodes{
        pattern
        isAdminEnforced
        requiresApprovingReviews
        pushAllowances(first:10){
          edges{
              node{
            actor
            id
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
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

