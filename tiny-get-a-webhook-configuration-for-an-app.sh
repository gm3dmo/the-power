.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/webhooks?apiVersion=2022-11-28#get-a-webhook-configuration-for-an-app  
# GET /app/hook/config

# This endpoint has to be presented with a jwt 
JWT=$(./tiny-call-get-jwt.sh)

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/hook/config"

