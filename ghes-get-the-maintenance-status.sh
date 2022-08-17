. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#get-the-maintenance-status
# GET /setup/api/maintenance

curl -L ${curl_custom_flags} \
        -u "api_key:${admin_password}" \
        https://${hostname}:8443/setup/api/maintenance
