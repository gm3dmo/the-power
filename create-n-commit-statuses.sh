.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/commits/statuses?apiVersion=2022-11-28#create-a-commit-status
# POST /repos/{owner}/{repo}/statuses/{sha}

# The state of the status.
# Can be one of: error, failure, pending, success
# If there is no first argument use a default value of "pending"
state="pending"
target_branch=${branch_name}
timestamp=$(date +%s)

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')

json_file=tmp/create-commit-status.json


turns=${1:-30}

for item in $(seq $turns)
do
  echo $item >&2
  item_l=$(printf "%05d" $item)
  status_context="ci/pwr-commit-status-required-${item_l}"

  jq -n \
        --arg state "${state}" \
        --arg target_url "https://example.com/build/status" \
        --arg description "The Power commit status ${item_l}: $status ran at: ${timestamp}" \
        --arg context "${status_context}" \
	'{ state : $state , target_url : $target_url, description: $description, context: $context }' > ${json_file}

  curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/statuses/${sha}" --data "${json_file}"
done
