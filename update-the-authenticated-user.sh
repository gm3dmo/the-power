.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.11/rest/users/users?apiVersion=2022-11-28#update-the-authenticated-user
# PATCH /user


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    user=$user
  else
    user=$1
fi


json_file=tmp/update-the-authenticated-user.json

blog="test.com/blog"

jq -n \
           --arg blog "${blog}" \
           '{
             blog: $blog,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user"  --data @${json_file}
