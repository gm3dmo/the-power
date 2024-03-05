.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#ipallowlistentry

enterprise=${1:-$enterprise}


export GH_TOKEN=${GITHUB_TOKEN}

gh api graphql --paginate -f enterprise="${enterprise}" -F query='
query($enterprise: String! $endCursor: String)  {
 enterprise(slug: $enterprise ) {
                    ownerInfo {
                        ipAllowListEntries(first: 2, after: $endCursor) {
                            nodes {
                                id
                                allowListValue
                                createdAt
                                isActive
                                name
                            }
                            pageInfo {
                                endCursor
                                hasNextPage
                            }
                        }
                    }
                }
}'
