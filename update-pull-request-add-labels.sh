.  ./.gh-api-examples.conf

# https://developer.github.com/v3/issues/#update-an-issue
# PATCH /repos/:owner/:repo/issues/:issue_number

json_file="test-data/update-pull-request-add-labels.json"
issue_number=$(./list-pull-requests.sh | jq '[.[].id] | max')

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_number} --data @${json_file}
