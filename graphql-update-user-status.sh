.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#changeuserstatus
# Updates the user's status.

user=$(./get-authenticated-user.sh | jq '.login' | tr -d '"')

# If the script is passed an argument $1 use that as the message
if [ -z "$1" ]
  then
    message=$(curl ${GITHUB_API_BASE_URL}/zen)
  else
    message=${1}
fi

# If the script is passed an argument $2 use that as the emoji
if [ -z "$2" ]
  then
    emoji=$("rocket")
  else
    emoji=${2}
fi


read -r -d '' graphql_script <<- EOF
mutation {
  changeUserStatus(
    input: {clientMutationId: "${user}", emoji: ":${emoji}:", message: "${message}"}
  ) {
    clientMutationId
    status {
      message
      emoji
      updatedAt
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
