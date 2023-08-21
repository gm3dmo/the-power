.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#delete-an-impersonation-oauth-token
# DELETE /admin/users/{username}/authorizations


if [ -z "$1" ]
  then
    user=${default_committer}
  else
    user=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/admin/users/${user}/authorizations
