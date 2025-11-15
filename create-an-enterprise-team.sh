.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-teams/enterprise-teams?apiVersion=2022-11-28#create-an-enterprise-team
# POST /enterprises/{enterprise}/teams


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    enterprise_team_name=${enterprise_team_name}
  else
    enterprise_team_name=$1
fi

enterprise_team_description="An enterprise team called ${enterprise_team_name}"

json_file=tmp/create-an-enterprise-team.json

jq -n \
           --arg name "${enterprise_team_name}" \
           --arg description "${enterprise_team_description}" \
           '{
             name : $name,
             description: $description
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/teams"  --data @${json_file}

