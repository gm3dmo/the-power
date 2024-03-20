.   ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions
# PUT /orgs/{org}/teams/{team_slug}/repos/{owner}/{repo}

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

team_id=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

json_file=tmp/add-or-update-team-repository-permissions.json

jq -n \
           --arg permission "${team_permission}" \
           '{
             permission: $permission,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/teams/${team_id}/repos/${org}/${repo}" --data @${json_file}
