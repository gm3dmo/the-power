. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/apps/apps?apiVersion=2022-11-28#get-an-app
# GET /apps/{app_slug}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    echo "Please provide app name as parameter after the script like ./get-an-app.sh your-app-name" && exit
  else
    app_name=$1
fi

curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/apps/${app_name}
