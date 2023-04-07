.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#create-a-team
# POST /orgs/:org/teams

json_file=tmp/childTeam.json

parent_team_id=2
d=$(date +%s)

DATA=$( jq -n \
                --arg nm "${d} child team of parent ${parent_team_id}" \
                --arg ds  "something something. child team." \
                --arg pm  "admin" \
                --arg pr  "closed" \
                --arg ptid ${parent_team_id} \
                '{name: $nm, description: $ds, permission: $pm, privacy: $pr, parent_team_id: ($ptid|tonumber) }'  )

echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams --data @${json_file}
