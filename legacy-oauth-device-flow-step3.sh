.  ./.gh-api-examples.conf

# https://docs.github.com/en/developers/apps/authorizing-oauth-apps#device-flow
# POST https://github.com/login/oauth/access_token

json_file=tmp/step3-device-flow.json
step1_response_file=tmp/step1-response.json
step3_response_file=tmp/step3-response.json

device_code=$(cat ${step1_response_file} | jq -r '.device_code')
grant_type="urn:ietf:params:oauth:grant-type:device_code"

echo ========== Step 3: Extract device code from step1 response file ========
echo
echo device code:
echo $device_code
echo
echo ========================================================================
echo
echo

echo ========== Step 3: Create step 3 device flow file =======================
echo
echo
jq -n \
                --arg client_id "${x_client_id}" \
                --arg device_code "${device_code}" \
                --arg grant_type "${grant_type}" \
                '{ client_id: $client_id, device_code: $device_code, grant_type: $grant_type }'  > ${json_file}
cat ${json_file} | jq -r
echo
echo ========================================================================
echo
echo

# This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com for the device flow.
if [ $hostname = "api.github.com" ];
then
  hostname="github.com"
fi


echo "========== Step 3: POST step 3 device flow file to /login/oauth/access_token ======================="
echo
echo
set -x
curl  ${curl_custom_flags} \
     -H "Content-type: application/json" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        https://${hostname}/login/oauth/access_token  --data @${json_file} -o ${step3_response_file}
set +x
echo
echo ========================================================================
echo
echo


echo ========== Step 3: Output the step 3 response file =====================
echo
cat ${step3_response_file} | jq -r
echo
echo ========================================================================
echo
echo
OAUTH_TOKEN=$(cat ${step3_response_file} | jq -r '.access_token')

echo ${OAUTH_TOKEN}
GITHUB_TOKEN=${OAUTH_TOKEN}

set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/consumed-licenses  | jq -r '.total_seats_consumed'
