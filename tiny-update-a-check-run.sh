.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/checks#update-a-check-run
# PATCH /repos/{owner}/{repo}/check-runs/{check_run_id}

target_branch=${branch_name}

#check_run_id may be obtained from: https://github.com/{owner}/{repo}/pull/2/checks

if [ -z "$1" ]
  then
    # this will get the last checkrun for the target_branch
    check_run_id=$(./list-check-runs-for-a-git-reference.sh $target_branch |   jq -r '.check_runs | last | .id')
  else
    check_run_id=$1
fi

if [ -z "$2" ]
  then
     head_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')
  else
     head_sha=$1
fi

GITHUB_APP_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

json_file=tmp/create-check-run.json

check_run_name="the-power-check-run-with-annotation"
check_run_status="completed"

#conclusion an be one of:·
# action_required, cancelled, failure, neutral, success,·
# skipped, stale, timed_out
check_run_conclusion="success"

# status Can be one of: queued, in_progress, completed
check_run_status="completed"

jq -n \
       --arg name "${check_run_with_annotation}" \
       --arg head_sha "${head_sha}" \
       --arg status "${check_run_status}" \
       --arg conclusion  "${check_run_conclusion}" \
       '{ head_sha: $head_sha, status: $status, name: $name, conclusion: $conclusion }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Authorization: Bearer ${GITHUB_APP_TOKEN}"  \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs/${check_run_id}" --data @${json_file}

