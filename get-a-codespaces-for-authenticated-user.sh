.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/codespaces/codespaces?apiVersion=2022-11-28#get-a-codespace-for-the-authenticated-user
# GET /user/codespaces/{codespace_name}


if [ -z "$1" ]
  then
    codespace_name=$(./list-codespaces-for-authenticated-user.sh | jq '.codespaces[0].name')
  else
    codespace_name=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/codespaces/${codespace_name}"

