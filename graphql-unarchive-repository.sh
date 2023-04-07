.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

$repo_id="R_kgDOGGLGSQ"

read -r -d '' graphql_script <<- EOF
UnArchiveRepository {
    unarchiveRepository(input:{clientMutationId:"true",repositoryId:"${repo_id}"}) {
        repository {
            isArchived,
        }
    }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"mutation\": \"$graphql_script\"}"

