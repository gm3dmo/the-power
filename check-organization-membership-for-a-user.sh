.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#check-organization-membership-for-a-user
# GET /orgs/{org}/members/{username}

if [ -z "$1" ]
  then
    username=${default_committer}
  else
    username=${1}
fi

echo "========= ${username} ================================" >&2
echo -n Response: >&2

curl ${curl_custom_flags} -s -o /dev/null -w "%{http_code}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/members/${username}
echo
echo "-----------------------------------------" >&2

echo

echo "Response if requester is an organization member and user is a member Status: 204 No Content" >&2
echo "Response if requester is not an organization member Status: 302 Found" >&2
echo "Response if requester is an organization member and user is not a member Status: 404 Not Found" >&2
echo "=========================================" >&2
