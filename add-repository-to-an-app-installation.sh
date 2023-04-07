.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#add-a-repository-to-an-app-installation
# PUT /user/installations/:installation_id/repositories/:repository_id

repository_name=${1:-testrepo}
repository_id=$(./list-repo.sh  ${repository_name}  | jq '.id')
installation_id=${default_installation_id}

curl -v ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/user/installations/${installation_id}/repositories/${repository_id}
