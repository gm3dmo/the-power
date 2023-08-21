.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/codespaces#delete-a-codespace-for-the-authenticated-user
# POST /user/codespaces

# If the script is passed an argument $1 use that as codespace name
if [ -z "$1" ]
  then
    codespace_name=$(./list-codespaces-for-authenticated-user.sh | jq '.codespaces[0].name')
  else
    codespace_name=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/user/codespaces/${codespace_name}
