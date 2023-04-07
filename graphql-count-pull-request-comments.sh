.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:
#


# If the script is passed an argument $1 use that as the name of the user to query
if [ -z "$1" ]
  then
    user=${default_committer}
  else
    user=$1
fi

merged_start_date=2021-06-05
merged_end_date=2021-06-05

read -r -d '' graphql_script <<- EOF
{
  search(first: 100, query: "is:pr org:$org is:closed merged:2021-06-05..2021-06-25 ", type:ISSUE) {
    pageInfo {
      startCursor
      hasNextPage
      endCursor
    }
    nodes {
      ... on PullRequest {
        title
        author {
            login
        }
        mergedAt
        createdAt
        comments {
            totalCount
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

