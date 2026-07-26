.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/agent-tasks/agent-tasks?apiVersion=2026-03-10#get-a-task-by-repo
# GET /agents/repos/{owner}/{repo}/tasks/{task_id}
# Requires github_api_version=2026-03-10 or later in .gh-api-examples.conf

if [ -z "$1" ]
  then
    echo "Usage: $0 <task_id> [repo]"
    exit 1
  else
    task_id=$1
fi

if [ -z "$2" ]
  then
    repo=$repo
  else
    repo=$2
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
        "${GITHUB_API_BASE_URL}/agents/repos/${owner}/${repo}/tasks/${task_id}"
