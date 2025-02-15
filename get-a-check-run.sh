.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/runs?apiVersion=2022-11-28#get-a-check-run
# GET /repos/{owner}/{repo}/check-runs/{check_run_id} 

# Check run id's can be seen at:
# https://github.com/{owner}/{repo}/pull/2/checks

if [ -z "$1" ]
  then
    check_run_id=$(./list-check-runs-for-a-git-reference.sh $target_branch |   jq -r '.check_runs | last | .id')
  else
    check_run_id=$1
fi

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs/${check_run_id}"

