.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#set-settings
# PUT /setup/api/settings

clear

echo
echo 'Warning: You need to make sure that you populate the "cert" field in the "test-data/cert.json" with your certificate'
echo 'or certificate chain before running this script.'


echo "Press enter to continue"

read x

curl -L ${curl_custom_flags} \
     -X PUT \
     -F 'settings=@test-data/cert.json' \
        "https://${hostname}:${mgmt_port}/setup/api/settings?api_key=${admin_password}" 

