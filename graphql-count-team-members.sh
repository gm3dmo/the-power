.  ./.gh-api-examples.conf



org=${1:-$org}

graphql_query=tmp/graphql_query.txt

cat <<EOF >$graphql_query
query { organization(login: "$org") { teams( first :1 query:"$team_slug" )  { edges { node{ members(first:1){ edges{ node{ login organizationVerifiedDomainEmails(login:"$org") } role } pageInfo { endCursor hasNextPage } totalCount } } } } } }
EOF


json_file=tmp/graphql-payload.json
jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d @${json_file} | jq

