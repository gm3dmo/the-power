.   ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/installations?apiVersion=2022-11-28#remove-a-repository-from-an-app-installation
# DELETE /user/installations/{installation_id}/repositories/{repository_id}


repository_name=${1:-testrepo}
repository_id=$(./list-repo.sh  ${repository_name}  | jq '.id')
installation_id=${app_installation_id}

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/installations/${installation_id}/repositories/${repository_id}"

