. .gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/codespaces#get-a-codespace-for-the-authenticated-user
# GET /user/codespaces/{codespace_name}

# If the script is passed an argument $1 use that as the codespace name
if [ -z "$1" ]
  then
    codespace_name=$(./list-codespaces-for-authenticated-user.sh | jq -r '.[0].name')
  else
    codespace_name=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/user/codespaces/${codespace_name}