.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#convertpullrequesttodraft
# Converts a pull request to draft.

if [ -z "$1" ]
  then
    pull_requestId=$(./list-pull-request.sh | jq '.node_id' | tr -d '"')
  else
    pull_requestId=${1}
fi

read -r -d '' graphql_script <<- EOF
mutation {
  convertPullRequestToDraft(input: {pullRequestId: "${pull_requestId}"}) {
    pullRequest {
      repository {
        id
        nameWithOwner
        owner {
          login
        }
        name
      }
      title
      id
      number
      isDraft
      createdAt
      closedAt
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
       ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}" | jq -r