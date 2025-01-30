.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-as-a-github-app-installation
#


# rate_limits: https://docs.github.com/en/developers/apps/building-github-apps/rate-limits-for-github-apps

JWT=$(./tiny-call-get-jwt.sh ${default_app_id} 2>/dev/null)

installation_id=${default_installation_id}

curl --silent ${curl_custom_flags} \
     -X POST \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/installations/${installation_id}/access_tokens"

