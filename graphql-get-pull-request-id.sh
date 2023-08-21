.  ./.gh-api-examples.conf

#

# Credit: https://stackoverflow.com/questions/69916356/how-do-i-enable-auto-merge-on-a-github-pull-request-via-the-rest-api

if [ -z "$1" ]
  then
    pull_request_id=${default_pull_request_id}
  else
    pull_request_id=$1
fi


read -r -d '' graphql_script <<- EOF
{
    repository(name: "$repo", owner: "$org") {
        pullRequest(number: $pull_request_id) {
                  id
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

