.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-as-a-github-app-installation
#

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    installation_id=${ent_app_installation_id}
  else
    installation_id=$1
fi

JWT=$(./ent-call-get-jwt.sh ${ent_app_id} 2>/dev/null)


curl --silent ${curl_custom_flags} \
     -X POST \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/installations/${installation_id}/access_tokens"

