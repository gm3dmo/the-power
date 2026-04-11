.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/webhooks?apiVersion=2022-11-28#list-deliveries-for-an-app-webhook
# GET /app/hook/deliveries

# This endpoint has to be presented with a jwt
JWT=$(./tiny-call-get-jwt.sh)

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github+json" \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/hook/deliveries"
