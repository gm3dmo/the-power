.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#create-a-team
# POST /orgs/:org/teams

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    team=${team_slug}
  else
    team=$1
fi

privacy="closed"
#privacy="secret"

json_file=tmp/team-data.json
rm -f ${json_file}

DATA=$( jq -n \
                --arg name "${team}" \
                --arg description "${team} is a ${privacy} team." \
                --arg privacy "$privacy" \
                '{name: $name, description: $description, privacy: $privacy }' )

echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams --data @${json_file}
