.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#remove-a-repository-from-an-app-installation
# DELETE /user/installations/{installation_id}/repositories/{repository_id}

repository_name=${1:-testrepo}
repository_id=$(./list-repo.sh  ${repository_name}  | jq '.id')
installation_id=${2:-1}

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/user/installations/${installation_id}/repositories/${repository_id}
