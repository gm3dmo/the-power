. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/checks#update-a-check-run
# PATCH /repos/{owner}/{repo}/check-runs/{check_run_id}

if [ -z "$1" ]
  then
     head_sha=$(curl --silent -H "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch}| jq -r '.object.sha')
  else
     head_sha=$1
fi

GITHUB_APP_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

json_file=tmp/create-check-run.json

#status="queued"
#status="in_progress"
status="completed"
name="code-coverage"
# See docs for conclusion states
conclusion="success"

check_run_id=${default_check_run_id}

jq -n \
       --arg name "${name}" \
       --arg head_sha "${head_sha}" \
       --arg status "${status}" \
       --arg conclusion  "${conclusion}" \
       '{ head_sha: $head_sha, status: $status, name: $name, conclusion: $conclusion }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Authorization: token ${GITHUB_APP_TOKEN}"  \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.antiope-preview+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs/${check_run_id} \
        --data @${json_file}
