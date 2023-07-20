.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#get-the-status-of-services-running-on-all-replica-nodes
# GET /manage/v1/replication/status

curl ${curl_custom_flags} \
        -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/replication/status"
