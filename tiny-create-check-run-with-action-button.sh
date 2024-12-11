.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/checks#create-a-check-run
# POST /repos/{owner}/{repo}/check-runs


branch_for_check=${branch_name}
 
if [ -z "$1" ]
  then
     head_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch_name}| jq -r '.object.sha')
  else
     head_sha=$1
fi


json_file=tmp/create-check-run.json


#The current status.
#Default: queued
#Can be one of: queued, in_progress, completed
status=completed
actions_label="pwr-action-1"
actions_description="pwr-action-1 description"
actions_identfier="pwr-action-1 identifier"
check_run_name="pwr-check-run-with-button"
conclusion=success


jq -n \
       --arg name "${check_run_name}" \
       --arg head_sha "${head_sha}" \
       --arg status "${status}" \
       --arg conclusion "${conclusion}" \
       --arg actions_label "${actions_label}" \
       --arg actions_description "${actions_description}" \
       --arg actions_identifier "${actions_identifier}" \
       '{ head_sha: $head_sha, conclusion: $conclusion, status: $status, name: $name, actions: [ { label: $actions_label, description: $actions_description, identifier: $actions_identifier  } ] }' > ${json_file}


GITHUB_APP_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_APP_TOKEN}"  \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs" --data @${json_file}
