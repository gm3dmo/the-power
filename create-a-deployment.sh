.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/deployments/deployments?apiVersion=2022-11-28#create-a-deployment
# POST /repos/{owner}/{repo}/deployments

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ref=${branch_name}
  else
    ref=$1
fi


json_file=tmp/create-a-deployment.json
jq -n \
           --arg ref "${ref}" \
           --arg environment "${default_environment_name}" \
          '{
             ref: $ref,
             environment: $environment
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/deployments" --data @${json_file}

