. .gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#package

org=${1:-$org}

graphql_query=tmp/graphql_query.txt
rm -f ${graphql_query}

cat <<EOF >$graphql_query
{
  repository(owner: "$org", name: "$repo") {
    dependencyGraphManifests {
      pageInfo {
        endCursor
        hasNextPage
      }
      edges {
        cursor
      }
      nodes {
        dependencies(first: 1) {
          nodes {
            packageManager
            packageName
            hasDependencies
            requirements
            repository {
              nameWithOwner
              licenseInfo {
                name
              }
              dependencyGraphManifests {
                nodes {
                  dependencies {
                    nodes {
                      packageName
                      hasDependencies
                      requirements
                      repository {
                        nameWithOwner
                        licenseInfo {
                          name
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
EOF

cat >&2 $graphql_query

json_file=tmp/graphql-vulnerabilities-payload.json
rm -f ${json_file}

jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.hawkgirl-preview+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file} | jq

rm -f ${graphql_query}
rm -f ${json_file}
