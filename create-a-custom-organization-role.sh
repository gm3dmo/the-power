.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/organization-roles?apiVersion=2022-11-28#create-a-custom-organization-role
# POST /orgs/{org}/organization-roles


if [ -z "$1" ]
  then
    org=${org}
  else
    org=$1
fi


name=${cr_name}
description=${cr_description}
permissions=${cr_permissions}


json_file=tmp/create-a-custom-organization-role.sh
jq -n \
           --arg name "${name}" \
           --arg description "${description}" \
           --argjson permissions "${permissions}" \
           '{
             name : $name,
             description: $description,
             permissions: $permissions,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles"  --data @${json_file}

