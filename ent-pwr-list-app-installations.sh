.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/apps?apiVersion=2022-11-28#list-installations-for-the-authenticated-app
# GET /app/installations


# This endpoint has to be presented with a jwt
# If the script is passed an argument $1 use that as the JWT
if [ -z "$1" ]
  then
    JWT=$(./ent-call-get-jwt.sh 2>/dev/null)
  else
    JWT=$1
fi

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/app/installations" | jq -r '
  .[] 
  | [.account.login, (.id|tostring)]
'

