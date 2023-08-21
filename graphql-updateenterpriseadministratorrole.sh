.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#updateenterpriseadministratorrole

# Call this like:
# ./graphql-updateenterpriseadministratorrole.sh your-username BILLING_MANAGER

# If the script is passed an argument $1 use that as the login
if [ -z "$1" ]
  then
    login="your-username"
  else
    login=$1
fi

# If the script is passed an argument $2 use that as the role
# Role values documented here:
# https://docs.github.com/en/graphql/reference/enums#enterpriseadministratorrole
#role=BILLING_MANAGER
#role=OWNER
if [ -z "$2" ]
  then
    role="BILLING_MANAGER"
  else
    role=$2
fi

graphql_query=tmp/graphql_query.txt

enterpriseId=$(./graphql-list-enterprise-id.sh | jq -r '.data.enterprise.id')

cat <<EOF >$graphql_query
mutation {
  updateEnterpriseAdministratorRole(input: {
    enterpriseId: "$enterpriseId",
    login: "$login",
    role: $role
  }) {
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

