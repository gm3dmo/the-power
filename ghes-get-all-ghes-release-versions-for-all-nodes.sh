.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.9/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#get-all-ghes-release-versions-for-all-nodes
# GET /manage/v1/version

curl ${curl_custom_flags} \
        -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/version"
