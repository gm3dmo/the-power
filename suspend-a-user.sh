.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/users?apiVersion=2022-11-28#suspend-a-user
# PUT /users/{username}/suspended

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    username=$default_committer
  else
    username=$1
fi


json_file=tmp/suspend-a-user.json

reason="The Power suspended $username for leave of absence"

jq -n \
           --arg reason "$reason" \
           '{
             reason : $reason
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/users/${username}/suspended"  --data @${json_file}

