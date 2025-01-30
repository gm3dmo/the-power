.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/apps?apiVersion=2022-11-28#unsuspend-an-app-installation
# DELETE /app/installations/{installation_id}/suspended

# This endpoint has to be presented with a jwt
JWT=$(./tiny-call-get-jwt.sh)

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/installations/${default_installation_id}/suspended"

