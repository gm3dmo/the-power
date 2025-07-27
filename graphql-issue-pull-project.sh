
.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

org_project_number=15
project_number=${org_project_number}

read -r -d '' graphql_script <<- EOF

{
  organization(login: "$org") {
    projectV2(number: $project_number ) {
      id
      title
      fields(first: 50) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id
            name
            options {
              id
              name
            }
          }
        }
      }
      items(first: 100) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          id
          content {
            ... on Issue {
              id
              number
              title
              url
            }
            ... on PullRequest {
              id
              number
              title
              url
            }
          }
          fieldValues(first: 50) {
            nodes {
              ... on ProjectV2ItemFieldSingleSelectValue {
                name
                field {
                  ... on ProjectV2SingleSelectField {
                    id
                    name
                  }
                }
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

if [ $1 == 'app' ]; then
   echo running as an app
   GITHUB_TOKEN=$(./tiny-dump-app-token.sh)
fi

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

