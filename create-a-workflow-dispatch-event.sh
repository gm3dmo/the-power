.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event
# POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches

# This script will send a workflow dispatch event. Don't confuse a workflow dispatch event with
# a repository dispatch event.

if [ -z "$1" ]
  then
    workflow_id=$(./list-repository-workflows.sh | jq '[.workflows[].id] | max')
  else
    workflow_id=$1
fi

json_file=tmp/create-a-workflow-dispatch-event.json

ref=${protected_branch_name}
# In the power you can use new_branch 
#ref_${branch_name}
# gh cli can do this also:
# gh workflow run the-power-workflow-simple --ref new_branch

jq -n \
        --arg ref "$ref" \
        '{
          ref: $ref
         }' > ${json_file}


curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/workflows/${workflow_id}/dispatches" --data @${json_file}
