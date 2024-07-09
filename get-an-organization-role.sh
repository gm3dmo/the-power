.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/organization-roles?apiVersion=2022-11-28#get-an-organization-role
# GET /orgs/{org}/organization-roles/{role_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
   role_id=$organization_role_id
  else
    role_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles/${role_id}"
