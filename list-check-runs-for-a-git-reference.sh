.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/checks/runs?apiVersion=2022-11-28#list-check-runs-for-a-git-reference
# GET /repos/{owner}/{repo}/commits/{ref}/check-runs

branch_for_ref=${branch_name}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ref=${branch_for_ref}
  else
    ref=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/commits/${ref}/check-runs"


# use the jq below to get just the id out:
# | jq -r '.check_runs | last | .id'
