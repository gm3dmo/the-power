.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/orgs?apiVersion=2022-11-28#remove-a-saml-sso-authorization-for-an-organization
# DELETE /orgs/{org}/credential-authorizations/{credential_id}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    credential_id=1
  else
    credential_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/credential-authorizations/${credential_id}"  

