.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/apps?apiVersion=2022-11-28#suspend-an-app-installation
# PUT /app/installations/{installation_id}/suspended

installation_id=${app_installation_id}

# This endpoint has to be presented with a jwt 
JWT=$(./tiny-call-get-jwt.sh)


curl ${curl_custom_flags} \
     -X PUT \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/installations/${installation_id}/suspended"

