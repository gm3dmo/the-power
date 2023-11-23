.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#enterpriseorganizationmembershipconnection
# 
# API Gap: This feature is not currently in the REST API for Enterprise administration https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin?apiVersion=2022-11-28


read -r -d '' graphql_script <<- EOF
{
  enterprise(slug: "$enterprise") {
    organizations(first: 100) {
      nodes {
        name
      }
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

