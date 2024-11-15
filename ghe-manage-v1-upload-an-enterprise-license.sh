.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#upload-an-enterprise-license
# PUT /manage/v1/config/license

# Note the documentation says: Uploads an enterprise license. This operation does not automatically activate the license.


if [ -z "$1" ]
  then
    license_file="tmp/enterprise.ghl"
  else
    license_file=$1
fi


apply=true

curl -L ${curl_custom_flags} \
        -X PUT \
        -u "api_key:${mgmt_password}" \
        -H "Content-Type: multipart/form-data" \
           "https://${hostname}:${mgmt_port}/manage/v1/config/license?apply=${apply}" --form "license=@${license_file}"  
