.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-teams/enterprise-teams?apiVersion=2022-11-28#get-an-enterprise-team
# GET /enterprises/{enterprise}/teams/${team_slug}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
   team_slug=${enterprise_team_name}
  else
    team_slug=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/teams/${team_slug}"  

