.  ./.gh-api-examples.conf

# https://docs.github.com/en/developers/apps/authorizing-oauth-apps#device-flow
# POST https://github.com/login/device/code

json_file=tmp/oauth-device-flow-step1.json
step1_response_file=tmp/step1-response.json

#scope="read:enterprise read:org read:audit_log"
scope=${oauth_token_scope}

jq -n \
                --arg client_id "${x_client_id}" \
                --arg scope  "${scope}" \
                '{ client_id: $client_id, scope: $scope  }'  > ${json_file}

echo ========== Step 1: json file for client and scope ======================
echo 
echo " the $json_file contents:"
echo
cat ${json_file} | jq -r
echo
echo ========================================================================


# This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com for the device flow.
if [ $hostname = "api.github.com" ];
then
  hostname="github.com"
fi

echo "========== Step 1: Deliver json file to /login/device/code ============="
echo 

set -x
curl ${curl_custom_flags} \
     -H "Content-type: application/json" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        https://${hostname}/login/device/code --data @${json_file}  --output ${step1_response_file}
set +x
echo
echo ========================================================================

echo
echo ============ Step 1: Display contents of response ======================
echo
echo " Contents of step 1 response file:"
echo
cat ${step1_response_file} | jq -r
echo 
echo ========================================================================


# Extract the user code:
user_code=$(cat ${step1_response_file} | jq -r '.user_code')

echo
echo
echo ============ Step 2: Open Browser, Login, Enter Device Code ============
echo 
echo "To complete device flow step 2:"
echo " - Press Enter to start a browser "
echo " - login to GitHub in the browser" 
echo " - Enter the user code: ${user_code} in the browser"
echo
read x

echo ========================================================================


if [ "${preferred_browser}" = "chrome" ]; then
    browser="Google Chrome"
elif [ "${preferred_browser}" = "firefox" ]; then
    browser="Firefox"
elif [ "${preferred_browser}" = "edge" ]; then
    browser="Microsoft Edge"
fi

incognito=false

# Chrome (Mac)
if [ "${browser}" = "Google Chrome" ];
then
    if [ "${incognito}" == "true" ]; then
        open -n -a "$browser" --args  -incognito "http://${hostname}/login/device"
    else
        open -n -a "$browser" --args --profile-directory="$chrome_profile" "http://${hostname}/login/device"
    fi
fi

# Firefox (Mac)
if [ "${browser}" = "Firefox" ];
then
    if [ "${incognito}" == "true" ]; then
        open -n -a "$browser" --args  -private "http://${hostname}/login/device"
    else
        open -n -a "$browser" --args  "http://${hostname}/login/device"
    fi
fi

# Edge (Mac)
if [ "${browser}" = "Microsoft Edge" ];
then
    if [ "${incognito}" == "true" ]; then
        open -n -a "$browser" --args  -incognito "http://${hostname}/login/device"
    else
        open -n -a "$browser" --args  "http://${hostname}/login/device"
    fi
fi


echo
echo
echo "================================================================""
echo "Now run legacy-oauth-device-flow-step3.sh to recover your token."
echo "================================================================""
