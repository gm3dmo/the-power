.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/runs?apiVersion=2022-11-28#list-check-runs-for-a-git-reference
# GET /repos/{owner}/{repo}/commits/{ref}/check-runs


if [ -z "$1" ]
  then
    ref=${branch_name}
  else
    ref=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/commits/${ref}/check-runs"

