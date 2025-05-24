.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#set-the-status-of-maintenance-mode
# POST /manage/v1/maintenance


if [ -z "$1" ]
  then
    enabled=$1
  else
    enabled=false
fi

json_file=tmp/set-the-status-of-maintenance-mode.json
jq -n \
           --argjson enabled "${enabled}" \
           '{
             enabled : $enabled | $enabled
           }' > ${json_file}


curl -L ${curl_custom_flags} \
     -H "Content-Type: application/json" \
     -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/maintenance" --data @${json_file}

