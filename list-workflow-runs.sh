.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/workflow-runs?apiVersion=2022-11-28#list-workflow-runs-for-a-repository
# GET /repos/{owner}/{repo}/actions/runs


if [ -z "$1" ]
  then
    workflow_id=$(./list-repository-workflows.sh | jq '[.workflows[].id] | max')
  else
    workflow_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/workflows/${workflow_id}/runs"

