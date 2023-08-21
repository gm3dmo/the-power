.  ./.gh-api-examples.conf

# Credit: https://github.com/orgs/community/discussions/24850


pull_request_id=${default_pull_request_id}

read -r -d '' graphql_script <<- EOF
{
  repository(name: "$repo", owner: "$org") {
     pullRequest(number: $pull_request_id) { 
        timelineItems(first: 20, itemTypes: [PULL_REQUEST_REVIEW, PULL_REQUEST_REVIEW_THREAD]) {
          nodes {
            __typename
            ... on PullRequestReview {
              authorAssociation
              author {
                login
                avatarUrl
                url
              }
              body
              createdAt
              state
              resourcePath
              comments(first: 5) {
                totalCount
                nodes {
                  pullRequestReview {
                    body
                  }
                  author {
                    login
                    avatarUrl
                    url
                  }
                  diffHunk
                  body
                  originalPosition
                  path
                  outdated
                }
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

