.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/members?apiVersion=2022-11-28#remove-public-organization-membership-for-the-authenticated-user
# DELETE /orgs/{org}/public_members/{username}

# If the script is passed an argument $1 use that as the username
if [ -z "$1" ]
  then
    username=$username
  else
    username=$1
fi

curl -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/public_members/${username}
