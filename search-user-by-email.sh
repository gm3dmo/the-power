.  ./.gh-api-examples.conf

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    user_to_search_for="user@example.com"
  else
    user_to_search_for=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/search/users?q=${user_to_search_for}"



