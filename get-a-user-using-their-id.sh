.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/users/users?apiVersion=2022-11-28#get-a-user-using-their-id
# GET /user/{account_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    account_id=$account_id
  else
    account_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/${account_id}"  

