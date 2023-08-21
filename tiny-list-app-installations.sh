.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#list-installations-for-the-authenticated-app
# GET /app/installations

# This endpoint has to be presented with a jwt

# If the script is passed an argument $1 use that as the JWT
if [ -z "$1" ]
  then
    JWT=$(./tiny-call-get-jwt.sh 2>/dev/null)
  else
    JWT=$1
fi

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
        ${GITHUB_API_BASE_URL}/app/installations

