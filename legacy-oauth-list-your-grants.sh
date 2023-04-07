.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/oauth-authorizations#list-your-grants
# GET /applications/grants

# Nothing about auth listed on the docs at above url
# document should mention:     -u  ${admin_user}:${admin_password} \

# If the script is passed an argument $1 use that as the client_id
if [ -z "$1" ]
  then
    client_id=${x_client_id}
  else
    client_id=$1
fi

curl ${curl_custom_flags} \
     -u  ${admin_user}:${admin_password} \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/applications/grants?client_id=${client_id}
