.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-a-deployment-status
# POST /repos/{owner}/{repo}/deployments/{deployment_id}/statuses

if [ -z "$1" ]
  then
    deployment_id=${default_deployment_id}
  else
    deployment_id=$1
fi

json_file=tmp/deployment.json
rm -f ${json_file}

state="success"

jq -n \
           --arg state "${state}" \
           --arg target_url "http://example.com/target-url" \
           --arg log_url "http://example.com/log-url" \
           --arg description "This is a deployment created by the REST API for demo purposes." \
           --arg environment "${default_environment_name}" \
          '{
             state: $state,
             target_url: $target_url,
             log_url: $log_url,
             description: $description,
             environment: $environment
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/deployments/${deployment_id}/statuses --data @${json_file}
