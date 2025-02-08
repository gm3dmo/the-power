.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#package

org=${1:-$org}

graphql_query=tmp/graphql_query.txt

cat <<EOF >$graphql_query
{
  organization(login: "$org") {
		name
    packages(first: 100) {
      nodes {
        packageType
        name
        latestVersion {
          version
        }
        repository {
          name
        }
        statistics {
          downloadsTotalCount
        }
      }
      totalCount
    }
  }
}
EOF


json_file=tmp/graphql-payload.json
jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d @${json_file} | jq

