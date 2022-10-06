. .gh-api-examples.conf

# https://docs.github.com/en/rest/teams/teams#get-a-team-by-name
# GET /orgs/{org}/teams/{team_slug}

if [ -z "$1" ]
  then
    team_slug=${team_slug}
  else
    team_slug=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}
