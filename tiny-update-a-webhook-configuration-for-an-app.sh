.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/webhooks?apiVersion=2022-11-28#update-a-webhook-configuration-for-an-app
# PATCH /app/hook/config

# This endpoint has to be presented with a jwt
JWT=$(./tiny-call-get-jwt.sh)

app_webhook_url="${smee_url:-https://example.com/webhook}"

json_file=tmp/tiny-update-a-webhook-configuration-for-an-app.json

jq -n \
           --arg url "${app_webhook_url}" \
           '{
             url: $url,
             content_type: "json",
             insecure_ssl: "0"
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/hook/config" --data @${json_file}

