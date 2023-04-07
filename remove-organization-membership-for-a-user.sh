.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#remove-organization-membership-for-a-user
# DELETE /orgs/{org}/memberships/{username}

# In contrast to remove-an-organization-member, this endpoint will remove a user who
# has been invited, but not yet accepted membership

if [ -z "$1" ]
  then
    username=${default_committer}
  else
    username=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${username}
