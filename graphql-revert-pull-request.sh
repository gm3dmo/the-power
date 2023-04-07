.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#revertpullrequest
# Create a pull request that reverts the changes from a merged pull request

if [ -z "$1" ]
  then
    PULLREQUEST_ID=$(./graphql-get-pull-request-id.sh | jq -r ".data.repository.pullRequest.id" 2>/dev/null)
  else
    PULLREQUEST_ID=${1}
fi

read -r -d '' graphql_script <<- EOF
mutation Revert {
  revertPullRequest(input: {pullRequestId: "${PULLREQUEST_ID}"}) {
    pullRequest {
      id
      title
      state
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
