.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.14/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#initialize-instance-configuration-with-license-upload
# POST /manage/v1/config/init


if [ -z "$1" ]
  then
    license_file="tmp/enterprise.ghl"
  else
    license_file=$1
fi


curl -L ${curl_custom_flags} \
        -u "api_key:${mgmt_password}" \
        -H "Content-Type: multipart/form-data" \
           "https://${hostname}:${mgmt_port}/manage/v1/config/init" --form "license=@${license_file}"  

# This fails 
#         "https://${hostname}:${mgmt_port}/manage/v1/config/init" --form "license=@${license_file}"  --form "password=${mgmt_password}"
# The error message:
# {"error":{"message":"failed to initialize config: invalid request: password already set","request_id":"602e3c4a-4a50-4d9b-8539-f0dfe794d3b4"}}
curl: (22) The requested URL returned error: 400


