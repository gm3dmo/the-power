.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/runs?apiVersion=2022-11-28#rerequest-a-check-run
# POST /repos/{owner}/{repo}/check-runs/{check_run_id}/rerequest


# If the script is passed an argument $1 use that as the check_run_id
if [ -z "$1" ]
  then
    echo "please add a check_run_id as the first argument"
    exit
  else
    check_run_id=$1
fi


json_file=tmp/skeleton.json

jq -n \
           --arg name "${repo}" \
           '{
             name : $name,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/check-runs/${check_run_id}/rerequest"
