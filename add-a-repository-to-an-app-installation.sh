.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/installations?apiVersion=2022-11-28#add-a-repository-to-an-app-installation
# PUT /user/installations/{installation_id}/repositories/{repository_id}


set -x
# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repository_id=$(./list-repo.sh | jq -r '.id')
  else
    repository_id=$1
fi


installation_id=${default_installation_id}


curl -v ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/installations/${installation_id}/repositories/${repository_id}" 

