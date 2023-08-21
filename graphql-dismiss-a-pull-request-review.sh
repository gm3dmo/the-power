.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#dismisspullrequestreview
# Script to dismiss a pull request review programatically using GraphQL API.

# If script is passed $1 use that as a the pullRequestReviewId

if [ -z "$1" ]
  then
    pullRequestReviewId=$(./list-reviews-for-pull-request.sh | jq -r '.[] | select(.state == "CHANGES_REQUESTED").node_id' | head -n 1)
  else
    pullRequestReviewId=$1
fi

# Wrap a graphql script for use with curl

read -r -d '' graphql_script <<- EOF
mutation dismiss_review {
  dismissPullRequestReview(
    input: {message: "I don't request changes!", pullRequestReviewId: "${pullRequestReviewId}"}) {
    clientMutationId
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"
