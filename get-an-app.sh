.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/apps?apiVersion=2022-11-28#get-an-app
# GET /apps/{app_slug}
#
# This has different behaviour for authentication between
# GHES and GHEC:
# https://docs.github.com/en/enterprise-server@3.8/rest/apps/apps


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    echo "Please provide app name as parameter after the script like ./get-an-app.sh your-app-name" && exit
  else
    app_slug=$1
fi


# This version is set up to work on GHES:
JWT=$(./tiny-call-get-jwt.sh 2>/dev/null)

set -x
curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${JWT}" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
        ${GITHUB_API_BASE_URL}/app/installations


