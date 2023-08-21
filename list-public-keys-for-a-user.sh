.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/users#list-public-keys-for-a-user
# GET /users/:username/keys

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    username=${admin_user}
  else
    username=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/users/${username}/keys
