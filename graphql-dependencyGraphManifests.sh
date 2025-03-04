.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#package

# For users looking for a CSV type solution for orgs on GitHub.com
# there is: https://github.com/andyfeller/gh-dependency-report

org=${1:-$org}
repo=${2:-$repo}

graphql_query=tmp/graphql_query.txt

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


json_file=tmp/graphql-vulnerabilities-payload.json
jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d @${json_file} | jq

