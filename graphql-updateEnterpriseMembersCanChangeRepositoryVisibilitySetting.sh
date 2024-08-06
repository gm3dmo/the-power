.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#updateenterprisememberscanchangerepositoryvisibilitysetting

graphql_query=tmp/graphql_query.txt

enterpriseId=$(./graphql-list-enterprise-id.sh | jq -r '.data.enterprise.id')

cat <<EOF >$graphql_query
mutation {
  updateEnterpriseMembersCanChangeRepositoryVisibilitySetting(
    input: { enterpriseId: "$enterpriseId", settingValue: ENABLED }
  ) {
    clientMutationId
  }
}
EOF

json_file=tmp/updateEnterpriseMembersCanChangeRepositoryVisibilitySetting.json

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

