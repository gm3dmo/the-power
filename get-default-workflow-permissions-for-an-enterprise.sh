.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/permissions?apiVersion=2022-11-28#get-default-workflow-permissions-for-an-enterprise
# GET /enterprises/{enterprise}/actions/permissions/workflow


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/permissions/workflow"

