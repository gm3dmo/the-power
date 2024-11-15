.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.14/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#trigger-a-ghe-config-apply-run
# POST /manage/v1/config/apply

curl -L ${curl_custom_flags} \
        -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/config/apply" -d '{"run_id":"cafebabe"}'

