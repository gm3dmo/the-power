.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/graphql/reference/objects
# search for rulesets on the objects page

read -r -d '' graphql_script <<- EOF
{
   repository(owner: "$org", name: "$repo") {
        rulesets(first: 10) {
          totalCount
          nodes {
            name
            target
            enforcement
          }
        }
   }
}
EOF


# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d "{ \"query\": \"$graphql_script\"}"

