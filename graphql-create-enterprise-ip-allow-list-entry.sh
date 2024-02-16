.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#createipallowlistentry

echo "Audit log entry: action:ip_allow_list_entry.create" >&2


ip_address=$(curl -s ifconfig.me/ip)


enterpriseId=$(./graphql-list-enterprise-id.sh | jq -r '.data.enterprise.id')
name=test1

owner_id=$enterpriseId

graphql_query=tmp/graphql_query.txt
rm -f ${graphql_query}

cat <<EOF >$graphql_query
mutation {
  createIpAllowListEntry(input: {ownerId: "$owner_id", allowListValue: "$ip_address", isActive: true, name: "$name" }) {
    ipAllowListEntry {
      id
      allowListValue
      createdAt
      isActive
      name
      owner {
        __typename
        ... on Enterprise {
          name
        }
      }
      updatedAt
    }
  }
}
EOF

json_file=tmp/graphql-payload.json
rm -f ${json_file}

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

rm -f ${graphql_query}
rm -f ${json_file}
