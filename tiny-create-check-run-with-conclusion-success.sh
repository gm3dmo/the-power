.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/runs?apiVersion=2022-11-28#create-a-check-run
# POST /repos/{owner}/{repo}/check-runs

branch_for_check=${branch_name}
 
if [ -z "$1" ]
  then
     head_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch_for_check}| jq -r '.object.sha')
  else
     head_sha=$1
fi

check_run_name="the-power-checkrun-with-conclusion-success"

#conclusion an be one of: 
# action_required, cancelled, failure, neutral, success, 
# skipped, stale, timed_out
check_run_conclusion="success"

# status Can be one of: queued, in_progress, completed
check_run_status="completed"


json_file=tmp/create-check-run.json

jq -n \
       --arg name "${check_run_name}" \
       --arg head_sha "${head_sha}" \
       --arg status "${check_run_status}" \
       --arg conclusion "${check_run_conclusion}" \
       '{ head_sha: $head_sha, status: $status, name: $name, conclusion: $conclusion }' > ${json_file}


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

curl ${curl_custom_flags} \
     -X POST \
     -H "Authorization: Bearer ${GITHUB_TOKEN}"  \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs" --data @${json_file}

