.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#securityadvisory

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ghsaId="GHSA-wmx6-vxcf-c3gr"
  else
    ghsaId=$1
fi


read -r -d '' graphql_script <<- EOF
query {
securityAdvisory(ghsaId: "$ghsaId") {
  ghsaId
  summary
  severity
  publishedAt
  updatedAt
    }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

curl --silent ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

