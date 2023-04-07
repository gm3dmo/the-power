.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/oauth-authorizations#list-your-authorizations
# GET /authorizations

client_id=${x_client_id}

curl ${curl_custom_flags} \
     -u  ${admin_user}:${admin_password} \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/authorizations?client_id=$client_id
