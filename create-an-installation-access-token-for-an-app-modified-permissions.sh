.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#create-an-installation-access-token-for-an-app
# POST /app/installations/{installation_id}/access_tokens

# This script gets an access token which has less privilege than the GitHub App
# actually has. For this case, create a GitHub app with write on contents and
# write on issues. The token created will have read only privileges on contents and issues.

installation_id=${default_installation_id}

JWT=$(./tiny-call-get-jwt.sh ${default_app_id})

curl ${curl_custom_flags} \
     -X POST \
     -H "Authorization: Bearer ${JWT}" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
        ${GITHUB_API_BASE_URL}/app/installations/${installation_id}/access_tokens --data '{"permissions": {"contents":"read", "issues": "read"} }'
