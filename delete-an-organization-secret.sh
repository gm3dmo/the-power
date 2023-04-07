.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#delete-an-organization-secret
# DELETE /orgs/{org}/actions/secrets/{secret_name}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    secret_name=${org_secret_name}
  else
    secret_name=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/actions/secrets/${secret_name}
