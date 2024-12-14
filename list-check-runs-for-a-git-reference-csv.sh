.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/runs?apiVersion=2022-11-28#list-check-runs-for-a-git-reference
# GET /repos/{owner}/{repo}/commits/{ref}/check-runs

branch_for_ref=${branch_name}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ref=${branch_for_ref}
  else
    ref=$1
fi

response_file=tmp/list-check-runs-for-a-git-reference.json

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/commits/${ref}/check-runs" > ${response_file}

jq -r '
  ["Cnt","Check Suite ID","Check Run ID","Name","Head SHA","App Name"],
  ( .check_runs | to_entries[] |
    [ ( .key | tonumber + 1 | tostring ),
      ( .value.check_suite.id | tostring ),
      ( .value.id | tostring ),
      .value.name,
      .value.head_sha,
      .value.app.name ] )
  | @csv' ${response_file} | csvlook --no-inference

