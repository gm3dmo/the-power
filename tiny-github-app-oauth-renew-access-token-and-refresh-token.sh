.  ./.gh-api-examples.conf

# https://docs.github.com/en/developers/apps/building-github-apps/refreshing-user-to-server-access-tokens
# POST https://github.com/login/oauth/access_token

json_file=tmp/renew-access-token-and-refresh-token.json
step3_response_file=tmp/step3-response.json
renew_response_file=tmp/renew-response.json

refresh_token=$(cat ${step3_response_file} | jq -r '.refresh_token')
grant_type="refresh_token"

echo "refresh_token: ${refresh_token}"
echo "grant_type: ${grant_type}"

jq -n \
                --arg refresh_token "${refresh_token}" \
                --arg grant_type "${grant_type}" \
                --arg client_id "${client_id}" \
                --arg client_secret "${app_client_secret}" \
                '{ refresh_token: $refresh_token, grant_type: $grant_type, client_id: $client_id, client_secret: $client_secret }'  > ${json_file}

cat ${json_file} | jq -r

# This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com for the device flow.
if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi


curl  ${curl_custom_flags} \
     -H "Content-type: application/json" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "https://${hostname}/login/oauth/access_token"  --data @${json_file} -o ${renew_response_file}

cat ${renew_response_file} | jq -r
