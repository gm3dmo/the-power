.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/commits/statuses?apiVersion=2022-11-28#create-a-commit-status
# POST /repos/{owner}/{repo}/statuses/{sha}

# The state of the status.
# Can be one of: error, failure, pending, success
# If there is no first argument use a default value of "pending"

if [ -z "$1" ]
  then
     state="pending"
  else
     state=$1
fi

if [ -z "$2" ]
  then
    status_context="ci/pwr-commit-status-required"
  else
    status_context=$2
fi


target_branch=${branch_name}
timestamp=$(date +%s)

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')

json_file=tmp/create-commit-status.json

jq -n \
        --arg state "${state}" \
        --arg target_url "https://example.com/build/status" \
        --arg description "The build status was: $status This is completely fake. The status ran at: ${timestamp}" \
        --arg context "${status_context}" \
	'{ state : $state , target_url : $target_url, description: $description, context: $context }' > ${json_file}

json_string=$(cat $json_file | jq )

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/statuses/${sha} --data "${json_string}"
