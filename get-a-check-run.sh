. .gh-api-examples.conf

# https://docs.github.com/en/rest/checks/runs#get-a-check-run
# GET /repos/{owner}/{repo}/check-runs/{check_run_id} 

if [ -z "$1" ]
  then
    check_run_id=${default_check_run_id}
  else
    check_run_id=${1}
fi

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs/${check_run_id}
