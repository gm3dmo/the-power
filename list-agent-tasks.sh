.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/agent-tasks/agent-tasks?apiVersion=2026-03-10#list-tasks
# GET /agents/tasks
# Requires github_api_version=2026-03-10 or later in .gh-api-examples.conf

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
        "${GITHUB_API_BASE_URL}/agents/tasks"

