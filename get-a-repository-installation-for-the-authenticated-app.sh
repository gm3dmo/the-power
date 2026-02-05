.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#get-a-repository-installation-for-the-authenticated-app
# GET /repos/{owner}/{repo}/installation


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


JWT=$(./tiny-call-get-jwt.sh ${app_id})
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${JWT}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/installation"  

