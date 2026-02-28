.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/organization-roles?apiVersion=2022-11-28#assign-an-organization-role-to-a-user
# PUT /orgs/{org}/organization-roles/users/{username}/{role_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    role_id=1
  else
    role_id=$1
fi

username=${pr_approver_name}

curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles/users/${username}/${role_id}"

