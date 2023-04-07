.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#review-pending-deployments-for-a-workflow-run
# POST /repos/{owner}/{repo}/actions/runs/{run_id}/pending_deployments

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

run_id=1

json_file=tmp/review-pending-deplyments-for-a-workflow-run.json

jq -n \
           --arg name "${repo}" \
           '{
             name : $name,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/runs/{run_id}/pending_deployments



curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL} --data @${json_file}


