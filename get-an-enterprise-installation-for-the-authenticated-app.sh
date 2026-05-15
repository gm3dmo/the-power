.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/apps?apiVersion=2026-03-10#get-an-enterprise-installation-for-the-authenticated-app
# GET /enterprises/{enterprise}/installation

# This endpoint has to be presented with a jwt
JWT=$(./ent-call-get-jwt.sh ${ent_app_id} 2>/dev/null)

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/installation"
