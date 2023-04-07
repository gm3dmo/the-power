.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

read -r -d '' graphql_script <<- EOF
{
  enterprise(slug:"$enterprise"){
    id
    name
      }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


# https://docs.github.com/en/graphql/guides/migrating-graphql-global-node-ids
# To facilitate migration to the new ID format, you can use the X-Github-Next-Global-ID header in your GraphQL API requests. The value of the X-Github-Next-Global-ID header can be 1 or 0. Setting the value to 1 will force the response payload to always use the new ID format for any object that you requested the id field for. Setting the value to 0 will revert to default behavior, which is to show the legacy ID or new ID depending on the object creation date.
# Setting this to 0:
#      -H "X-Github-Next-Global-ID: 1" \
# will return the legacy id.

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "X-Github-Next-Global-ID: 1" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"


