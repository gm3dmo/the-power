.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/artifacts?apiVersion=2022-11-28#list-workflow-run-artifacts
# GET /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    run_id=$(./list-workflow-runs-for-a-repository.sh |  jq -r '.workflow_runs[-1].id')
  else
    run_id=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/runs/${run_id}/artifacts" 
