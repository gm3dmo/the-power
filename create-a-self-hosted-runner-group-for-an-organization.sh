.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/self-hosted-runner-groups?apiVersion=2022-11-28#create-a-self-hosted-runner-group-for-an-organization
# POST /orgs/{org}/actions/runner-groups


if [ -z "$1" ]
  then
    name=${org_shr_group_name}
  else
    name=$1
fi


json_file=tmp/create-a-self-hosted-runner-group-for-an-organization.json
jq -n \
           --arg name "${name}" \
           '{
             name : $name,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/runner-groups"  --data @${json_file}

