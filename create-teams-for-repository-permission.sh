.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/teams?apiVersion=2022-11-28#create-a-team
# POST /orgs/{org}/teams

# Permissions for teams are from:
# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions

for team_type in ${available_team_permissions}
do

    prefix=pwr-team
    team_name="${prefix}-${team_type}"
    team=$team_name
    privacy="closed"
    #privacy="secret"
    json_file=tmp/team-permission-data.json
    
     jq -n \
                    --arg name "${team}" \
                    --arg description "${team} is a ${privacy} team. See: https://docs.github.com/en/enterprise-cloud@latest/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions" \
                    --arg privacy "$privacy" \
                    '{name: $name, description: $description, privacy: $privacy }' > ${json_file}

 cat $json_file | jq -r
    
    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${GITHUB_API_BASE_URL}/orgs/${org}/teams" --data @${json_file} > tmp/create-team-${team}.json

done
