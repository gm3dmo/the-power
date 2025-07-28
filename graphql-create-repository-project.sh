.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

owner_id=$(./list-organization.sh | jq -r '.node_id')
repo_id=$(./list-repo.sh | jq -r '.node_id')

ts=$(date +'%s')
title="The Power Repository Project ${ts}"

read -r -d '' graphql_script <<- EOF
mutation {
  createProjectV2(
    input: {
      ownerId: "${owner_id}"
      title: "${title}"
      repositoryId: "$repo_id"
    }
  ) {
    projectV2 {
      id
      title
      url
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

if [ -z $1 ]; then
    :
else
    # Act as a github app if any argument is passed:
    GITHUB_TOKEN=$(./tiny-dump-app-token.sh)
fi

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

