.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#create-an-installation-access-token-for-an-app
# POST /app/installations/{installation_id}/access_tokens

# This script gets an access token which has less privilege than the GitHub App
# actually has. For this case, create a GitHub app with write on contents and
# write on issues. The token created will have read only privileges on contents and issues.


installation_id=${default_installation_id}

JWT=$(./tiny-call-get-jwt.sh ${default_app_id})

json_file=tmp/create-an-installation-access-token-for-an-app.json

# Add any permissions you want here (must be valid json):
permissions='{"contents": "write", "issues": "write"}'

jq -n \
       --argjson permissions "${permissions}" \
           '{
             permissions :  $permissions 
           }' > ${json_file}

echo ===================== >&2
cat ${json_file} | jq -r >&2
echo ===================== >&2


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/installations/${installation_id}/access_tokens" --data @${json_file}

