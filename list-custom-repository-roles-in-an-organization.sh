.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/custom-roles?apiVersion=2022-11-28#list-custom-repository-roles-in-an-organization
# GET /orgs/{org}/custom-repository-roles


# Query: is this a docs error? I can only get this to work
# with 

if [ -z "$1" ]
  then
    #org=${org}
    organization_id=$(./list-organization.sh | jq -r '.id')
  else
    #org=$1
    organization_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/organizations/${organization_id}/custom_roles"

