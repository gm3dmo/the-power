.  ./.gh-api-examples.conf

# 

# Rest Example: list-organization.sh

read -r -d '' graphql_script <<- EOF
{
  organization(login: "$org") {
        id
        name
        description
        url
        createdAt
        updatedAt
  }
}
EOF

graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

