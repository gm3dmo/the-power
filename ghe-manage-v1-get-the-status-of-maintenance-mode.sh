.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#get-the-status-of-maintenance-mode
# GET /manage/v1/maintenance


curl -L ${curl_custom_flags} \
        -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/maintenance"

