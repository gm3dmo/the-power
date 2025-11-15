.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-teams/enterprise-teams?apiVersion=2022-11-28#update-an-enterprise-team
# PATCH /enterprises/{enterprise}/teams/{team_slug}


team_slug=${enterprise_team_name}
new_team_name="${team_slug}-new"

json_file=tmp/update-an-enterprise-team.json

jq -n \
           --arg name "${new_team_name}" \
           '{
             name : $name,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/teams/${team_slug}"  --data @${json_file}

