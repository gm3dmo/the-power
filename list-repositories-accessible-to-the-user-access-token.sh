.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/apps/installations?apiVersion=2022-11-28#list-repositories-accessible-to-the-user-access-token
# GET /user/installations/{installation_id}/repositories


installation_id=${default_installation_id}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/installations/${installation_id}/repositories"

