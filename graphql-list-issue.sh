.  ./.gh-api-examples.conf

# Credit: https://github.com/orgs/community/discussions/24850




# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    issue_number=${default_issue_id}
  else
    issue_number=$1
fi



read -r -d '' graphql_script <<- EOF
{
  repository(name: "$repo", owner: "$org") {
    issue(number: $issue_number ) {
      id
      title
      body
      createdAt
      updatedAt
      author {
        login
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

