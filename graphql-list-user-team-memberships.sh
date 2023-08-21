.  ./.gh-api-examples.conf


user=${default_committer}

read -r -d '' graphql_script <<- EOF
{
  organization(login: "$org") {
    teams(first: 100, userLogins: ["$user"]) {
      totalCount
      edges {
        node {
          name
          description
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

