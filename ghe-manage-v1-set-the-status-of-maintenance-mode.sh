.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#set-the-status-of-maintenance-mode
# POST /manage/v1/maintenance


json_file=tmp/set-the-status-of-maintenance-mode.json

enabled=false

jq -n \
           --argjson enabled "${enabled}" \
           '{
             enabled : $enabled
           }' > ${json_file}


echo json file being submitted:
echo

cat ${json_file} | jq -r

set -x
curl -L ${curl_custom_flags} \
     -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/maintenance" --data @${json_file}

