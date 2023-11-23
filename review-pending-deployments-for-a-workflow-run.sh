.  ./.gh-api-examples.conf

# https://docs.github.com/en/free-pro-team@latest/rest/actions/workflow-runs?apiVersion=2022-11-28#review-pending-deployments-for-a-workflow-run
# POST /repos/{owner}/{repo}/actions/runs/{run_id}/pending_deployments

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

run_id=$(./list-workflow-runs-for-a-repository.sh | jq -r '.workflow_runs[-1].id')

json_file=tmp/review-pending-deplyments-for-a-workflow-run.json

environment_id=$(./get-an-environment.sh| jq -r '.id')

jq -n \
           --argjson environment_id ${environment_id} \
           '{ "environment_ids":[ $environment_id ], "state":"approved","comment":"Ship it!" }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/runs/${run_id}/pending_deployments" -d @${json_file}

