.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#mergequeueentry

read -r -d '' graphql_script <<- EOF
{
  organization(login: "$org") {
    repository(name: "$repo") {
      nameWithOwner
      mergeQueue {
        nextEntryEstimatedTimeToMerge
        entries (first: 100) {
          nodes {
            pullRequest {
              number
              title
            }
          }
        }
      }
    }
  }
}
EOF

echo $graphql_script

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

echo $graphql_script

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

