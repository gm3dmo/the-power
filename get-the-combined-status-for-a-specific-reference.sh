.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.5/rest/commits/statuses#get-the-combined-status-for-a-specific-reference
# GET /repos/{owner}/{repo}/commits/{ref}/status

target_branch=${1:-new_branch}

#sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')

ref=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')


set -x
curl --silent ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${ref}/status
