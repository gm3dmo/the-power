.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#user

username=$1

read -r -d '' graphql_script <<- EOF
{
  user(login: "$username"){
    id
    login
}
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "X-Github-Next-Global-ID: 1" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

