.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/webhooks?apiVersion=2022-11-28#get-a-delivery-for-an-app-webhook
# GET /app/hook/deliveries/{delivery_id}

# This endpoint has to be presented with a jwt
JWT=$(./tiny-call-get-jwt.sh)

# If the script is passed an argument $1 use that as the delivery_id
if [ -z "$1" ]
  then
    delivery_id=$(./tiny-list-deliveries-for-an-app-webhook.sh | jq -r '.[-1] .id')
  else
    delivery_id=$1
fi


curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/hook/deliveries/${delivery_id}"

