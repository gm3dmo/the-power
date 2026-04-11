source ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/webhooks?apiVersion=2022-11-28#redeliver-a-delivery-for-an-app-webhook
# POST /app/hook/deliveries/{delivery_id}/attempts


# This endpoint has to be presented with a jwt
JWT=$(./tiny-call-get-jwt.sh)

# If passed an argument use that as the delivery_id, otherwise find the last failed delivery
if [ -z "$1" ]
  then
    delivery_id=$(./tiny-list-deliveries-for-an-app-webhook-failed.sh | jq -r 'last | .id')
  else
    delivery_id=$1
fi


curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.json" \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/hook/deliveries/${delivery_id}/attempts"

