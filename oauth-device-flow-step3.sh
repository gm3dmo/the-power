. .gh-api-examples.conf

# https://docs.github.com/en/developers/apps/authorizing-oauth-apps#device-flow
# POST https://github.com/login/oauth/access_token

json_file=/tmp/step3-device-flow.json
step1_response_file=/tmp/step1-response.json
step3_response_file=/tmp/step3-response.json

device_code=$(cat ${step1_response_file} | jq -r '.device_code')
grant_type="urn:ietf:params:oauth:grant-type:device_code"

echo device code:
echo $device_code

jq -n \
                --arg client_id "${client_id}" \
                --arg device_code "${device_code}" \
                --arg grant_type "${grant_type}" \
                '{ client_id: $client_id, device_code: $device_code, grant_type: $grant_type }'  > ${json_file}

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
     -H "Authorization: token ${GITHUB_TOKEN}" \
        https://${hostname}/login/oauth/access_token  --data @${json_file} -o ${step3_response_file}

cat ${step3_response_file} | jq -r
