.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/checks#create-a-check-run
# POST /repos/{owner}/{repo}/check-runs


branch_for_check=${branch_name}
 
if [ -z "$1" ]
  then
     head_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch_for_check}| jq -r '.object.sha')
  else
     head_sha=$1
fi

check_run_name="the-power-check-run-with-annotation"
check_run_status="queued"
# status Can be one of: queued, in_progress, completed

json_file=tmp/create-check-run.json
jq -n \
       --arg name "${check_run_name}" \
       --arg head_sha "${head_sha}" \
       --arg status "${check_run_status}" \
       '{ head_sha: $head_sha, status: $status, name: $name, "output":{"title":"Mighty Readme report","summary":"testing a failure","text":"This should annotate the first line of a commit ","annotations":[{"path":".gitattributes","annotation_level":"failure","title":"Spell Checker","message":"Check your spelling for 'banaas'.","raw_details":"Do you mean 'bananas' or 'banana'?","start_line":1,"end_line":1}]}}' > ${json_file}

# Only GitHub Apps may use the checks api so 
GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

curl ${curl_custom_flags} \
     -X POST \
     -H "Authorization: Bearer ${GITHUB_TOKEN}"  \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs"  --data @${json_file}

