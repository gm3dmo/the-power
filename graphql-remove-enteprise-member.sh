.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/graphql/reference/mutations#removeenterprisemember

if [ -z "$1" ]
  then
    uid="the-uid-of-the-user-to-remove"
  else
    uid=$1
fi

### the uid is the graphql "U_12345=" id
# which you can grab with the script
# graphql-list-user-id.sh

graphql_query=tmp/graphql_query.txt

ent_id=$(./graphql-list-enterprise-id.sh | jq -r '.data.enterprise.id')

cat <<EOF >$graphql_query
mutation removeMember {
  removeEnterpriseMember(
    input: { enterpriseId: "$ent_id", userId: "$uid"}
  ) {
    clientMutationId
  }
}
EOF

json_file=tmp/graphql-payload.json

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

