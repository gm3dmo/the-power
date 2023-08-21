.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/projects#get-project-permission-for-a-user
# GET /projects/{project_id}/collaborators/{username}/permission

# If the script is passed an argument $1 use that as the username
if [ -z "$1" ]
  then
    username=${default_committer}
  else
    username=$1
fi

#project_id=$(./list-organization-projects.sh 2>/dev/null | jq '.[] | .id' | sort | head -1)
project_id=1

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.inertia-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/projects/${project_id}/collaborators/${username}/permission
