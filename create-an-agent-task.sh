.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/agent-tasks/agent-tasks?apiVersion=2026-03-10#create-a-task
# POST /agents/repos/{owner}/{repo}/tasks
# Requires github_api_version=2026-03-10 or later in .gh-api-examples.conf

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

if [ -z "$2" ]
  then
    prompt="Fix the login button on the homepage"
  else
    prompt=$2
fi

if [ -z "$3" ]
  then
    base_ref="main"
  else
    base_ref=$3
fi

json_file=tmp/create-an-agent-task.json

jq -n \
        --arg prompt "${prompt}" \
        --arg base_ref "${base_ref}" \
        '{
          prompt : $prompt,
          base_ref : $base_ref
        }' > ${json_file}

set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
        "${GITHUB_API_BASE_URL}/agents/repos/${owner}/${repo}/tasks" --data @${json_file}
