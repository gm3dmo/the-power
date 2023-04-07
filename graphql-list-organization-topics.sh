.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

# https://github.slack.com/archives/C0EUR2AC9/p1655976938742989?thread_ts=1655975939.157829&cid=C0EUR2AC9

read -r -d '' graphql_script <<- EOF
query organizationTopics ($organization: String!, $cursor: String) {
  organization(login: $organization) {
    repositories(first: 100, orderBy: {field:NAME, direction:ASC}, after: $cursor) {
      pageInfo {hasNextPage, endCursor}
      nodes {
        # Technically this could need pagination, but it would be odd if there were more that 100 topics on a repo in practice
        repositoryTopics(first: 100) {
          nodes {
            topic {
              name
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

