.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/organization-roles?apiVersion=2022-11-28#create-a-custom-organization-role
# POST /orgs/{org}/organization-roles


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


json_file=tmp/create-a-custom-organization-role.json

jq -n \
           --arg name "Custom Role Manager" \
           --arg description "Permissions to manage custom roles within an org" \
           '{
             name : $name,
             descrption : $description,
             permissions : ["write_organization_custom_repo_role","write_organization_custom_org_role","read_organization_custom_repo_role","read_organization_custom_org_role"]
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles"  --data @${json_file}

