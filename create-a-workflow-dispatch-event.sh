.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event
# POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches

# This script will send a workflow dispatch event. Don't confuse a workflow dispatch event with
# a repository dispatch event.

if [ -z "$1" ]
  then

if [ -z "$1" ]
  then
    workflow_id=$(./list-repository-workflows.sh | jq '[.workflows[].id] | max')
  else
    workflow_id=$1
fi

json_file=tmp/create-a-workflow-dispatch-event.json

ref=main
logLevel="info"

jq -n \
        --arg ref "$ref" \
        --arg logLevel "$logLevel" \
        '{
          ref: $ref
         }' > ${json_file}



repo=repo-zeddy1
set -x
GITHUB_TOKEN=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
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/workflows/${workflow_id}/dispatches" --data '{"ref" : "main"}'

