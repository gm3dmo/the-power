.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/deployments/deployments?apiVersion=2022-11-28#create-a-deployment
# POST /repos/{owner}/{repo}/deployments

ref=$1

json_file=tmp/deployment.json
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

