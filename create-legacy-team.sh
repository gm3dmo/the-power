.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#create-a-team
# POST /orgs/:org/teams

json_file=tmp/teamData
rm -f ${json_file}

DATA=$( jq -n \
                --arg nm "legacy-${team}" \
                --arg ds  "something something." \
                --arg pm  "admin" \
                --arg pr  "closed" \
                '{name: $nm, description: $ds, permission: $pm, privacy: $pr }' )

echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams --data @${json_file}

rm -f ${json_file}
