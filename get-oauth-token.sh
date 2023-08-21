.  ./.gh-api-examples.conf

# URL
# CALL

user="some_user"
password="some_password" \

curl ${curl_custom_flags} \
     -u ${user}:${password}\
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/authorizations -d '{ "scopes": [ ], "note": "noted3" }'
