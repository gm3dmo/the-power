.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/workflow-runs#get-a-workflow-run-attempt
# GET /repos/{owner}/{repo}/actions/runs/{run_id}/attempts/{attempt_number}
#
run_id=
attempt_number=

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/runs/${run_id}/attempts/${attempt_number}
