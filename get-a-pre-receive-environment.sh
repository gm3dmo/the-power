.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/enterprise-admin#get-a-pre-receive-environment
# GET /admin/pre-receive-environments/{pre_receive_environment_id}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/pre-receive-environments/${pre_receive_environment_id}
