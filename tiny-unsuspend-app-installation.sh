.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#unsuspend-an-app-installation
# DELETE /app/installations/{installation_id}/suspended

# This endpoint has to be presented with a jwt
JWT=$(./tiny-call-get-jwt.sh)

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Authorization: Bearer ${JWT}" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
        ${GITHUB_API_BASE_URL}/app/installations/${default_installation_id}/suspended
