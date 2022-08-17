. .gh-api-examples.conf

# https://docs.github.com/en/developers/apps/authorizing-oauth-apps#device-flow
# POST https://github.com/login/device/code

json_file=/tmp/step1.json
step1_response_file=/tmp/step1-response.json

scope="user"

jq -n \
                --arg client_id "${client_id}" \
                --arg scope  "${scope}" \
                '{ client_id: $client_id, scope: $scope  }'  > ${json_file}

echo " the $json_file contents:"
cat ${json_file} | jq -r
echo =================================


# This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com for the device flow.
if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi

set -x
curl ${curl_custom_flags} \
     -v \
     -H "Content-type: application/json" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        https://${hostname}/login/device/code --data @${json_file}  -o ${step1_response_file}



echo " Contents of step1 response file:"
cat ${step1_response_file} | jq -r
echo =================================

user_code=$(cat ${step1_response_file} | jq -r '.user_code')

echo "To complete device flow step 2. Enter the user code: ${user_code}"

open -n -a "Google Chrome" --args  "http://${hostname}/login/device"

