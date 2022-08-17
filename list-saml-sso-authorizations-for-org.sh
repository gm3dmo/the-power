. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#list-saml-sso-authorizations-for-an-organization
# GET /orgs/{org}/credential-authorizations


# If the script is passed an argument $1 use that as the org
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/credential-authorizations
