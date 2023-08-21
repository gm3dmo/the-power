.  ./.gh-api-examples.conf

# 


org=${1:-$org}

graphql_query=tmp/graphql_query.txt
rm -f ${graphql_query}

cat <<EOF >$graphql_query
query{
  organization(login:"$org") {
    repositories(first:100){
      nodes{
        name
        nameWithOwner
        defaultBranchRef {
          name
          branchProtectionRule {
            isAdminEnforced
            dismissesStaleReviews
            allowsForcePushes
            allowsDeletions
          }
        }
      }
        }
      }
}
EOF

cat >&2 $graphql_query

json_file=tmp/graphql-organization-vulnerabilities-payload.json
rm -f ${json_file}

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

rm -f ${graphql_query}
rm -f ${json_file}
