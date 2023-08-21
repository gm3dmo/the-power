.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#remove-a-repository-from-an-app-installation
# GET /user/installations/{installation_id}/repositories

installation_id=${default_installation_id}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/user/installations/${installation_id}/repositories
