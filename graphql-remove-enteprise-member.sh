.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/graphql/reference/mutations#removeenterprisemember


set -x
# If the script is passed an argument $1 use that as the login
if [ -z "$1" ]
  then
    uid="your-user-id"
  else
    uid=$1
fi

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

