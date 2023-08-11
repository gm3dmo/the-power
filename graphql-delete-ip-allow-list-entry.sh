.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#deleteipallowlistentry
# Usage:
#   $ bash graphql-list-ip-allow-list-entries.sh | \
#       jq -r '.data.organization.ipAllowListEntries.nodes[].id' | \
#       xargs -I {} bash graphql-delete-ip-allow-list-entry.sh {}

echo "Audit log entry: action:ip_allow_list_entry.destroy" >&2


ipAllowListEntryId=$1

graphql_query=tmp/graphql_query.txt
rm -f ${graphql_query}

cat <<EOF >$graphql_query
mutation {
  deleteIpAllowListEntry(input: {ipAllowListEntryId: "$ipAllowListEntryId"}) {
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
        ... on Organization {
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
