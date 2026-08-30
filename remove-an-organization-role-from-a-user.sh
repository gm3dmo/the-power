.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/organization-roles?apiVersion=2022-11-28#remove-an-organization-role-from-a-user
# DELETE /orgs/{org}/organization-roles/users/{username}/{role_id}


if [ -z "$1" ]
  then
    role_id=1
  else
    role_id=$1
fi


# a username of your choice 
username=${pr_approver_name}


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles/users/${username}/${role_id}"

