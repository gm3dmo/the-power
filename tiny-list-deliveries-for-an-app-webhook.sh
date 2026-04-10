.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.18/rest/apps/webhooks?apiVersion=2022-11-28#list-deliveries-for-an-app-webhook
# GET /app/hook/deliveries

# This endpoint has to be presented with a jwt 
JWT=$(./tiny-call-get-jwt.sh)

hook_delivery_status="failure"
#hook_delivery_status="success"

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/hook/deliveries?status=${hook_delivery_status}&per_page=1"
