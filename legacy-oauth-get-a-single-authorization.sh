.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/oauth-authorizations#get-a-single-authorization
# GET /authorizations/{authorization_id}

# If the script is passed an argument $1 use that as the authorization_id
if [ -z "$1" ]
  then
    authorization_id=$authorization_id
  else
    authorization_id=$1
fi

curl ${curl_custom_flags} \
     -u  ${admin_user}:${admin_password} \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/authorizations/${authorization_id}
