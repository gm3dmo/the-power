.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/users?apiVersion=2022-11-28#update-the-username-for-a-user
# PATCH /admin/users/{username}


old_username=${1}
username=${2}


json=tmp/update-the-username-for-a-user.json
jq -n \
  --arg new_username "${new_username}" \
  '{ "login" : $new_username }'  > ${json}


curl ${curl_custom_flags} \
-X PATCH \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
        "${GITHUB_API_BASE_URL}/admin/users/${username} --data @$json"

