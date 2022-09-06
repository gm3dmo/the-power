. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-a-commit-status
# POST /repos/:owner/:repo/statuses/:sha


if [ -z "$1" ]
  then
    status_context="ci-test/this-check-is-required"
  else
    status_context="ci-test/this-check-is-optional"
fi

target_branch=${branch_name}

sha=$(curl --silent -H "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')

status="success"
timestamp=$(date +%s)


json_file=tmp/create-commit-status.json

jq -n \
        --arg state "${status}" \
        --arg target_url "https://example.com/build/status" \
        --arg description "The build status was: $status This is completely fake. The status ran at: ${timestamp}" \
        --arg context "${status_context}" \
	'{ state : $state , target_url : $target_url, description: $description, context: $context }' > ${json_file}

json_string=$(cat $json_file | jq )

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/statuses/${sha} --data "${json_string}"
