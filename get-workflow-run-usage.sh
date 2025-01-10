.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/workflow-runs?apiVersion=2022-11-28#get-workflow-run-usage
# GET /repos/{owner}/{repo}/actions/runs/{run_id}/timing

run_id=$(./list-workflow-runs-for-a-repository.sh |  jq -r '.workflow_runs[-1].id')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/runs/${run_id}/timing"
