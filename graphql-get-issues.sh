.  ./.gh-api-examples.conf

# Gets the issues filtered by author

if [ -z "$1" ]
  then
    filter=${team_admin}
  else
    filter=$1
fi

read -r -d '' graphql_script <<- EOF
{
  repository(owner: "${org}", name: "${repo}") {
    issues(
      orderBy: {field: UPDATED_AT, direction: DESC}
      filterBy: {createdBy: "${filter}"}
      first: 100
    ) {
      nodes {
        author {
          login
        }
        createdAt
        title
        closed
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
