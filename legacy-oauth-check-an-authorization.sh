.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.3/rest/reference/apps#check-an-authorization
# GET /applications/{client_id}/tokens/{access_token}

access_token=$1
client_id=${x_client_id}

curl -L ${curl_custom_flags} \
     -X GET \
     -u ${client_id}:${client_secret} \
     -H "Content-type: application/json" \
     -H "Accept: application/vnd.github.v3+json" \
        https://${hostname}/api/v3/applications/${client_id}/tokens/${access_token}
