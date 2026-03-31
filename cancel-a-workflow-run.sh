.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/workflow-runs#cancel-a-workflow-run
# POST /repos/{owner}/{repo}/actions/runs/{run_id}/cancel

run_id=$1

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/runs/${run_id}/cancel"
