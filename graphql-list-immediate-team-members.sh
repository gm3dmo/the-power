.  ./.gh-api-examples.conf

# Lists the immediate members of a team.


# If the script is passed an argument $1 use that as the name of the user to query
if [ -z "$1" ]
  then
    team=${team_slug}
  else
    team=$1
fi

read -r -d '' graphql_script <<- EOF
{
  organization(login: "$org") {
    team(slug: "$team") {
      name
      members(membership: IMMEDIATE) {
        totalCount
        nodes {
          login
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

