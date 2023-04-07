.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#create-a-team
# POST /orgs/:org/teams

# This team won't get assigned a pull request as CODEOWNERS for reasons unknown


team="bad-team"

json_file=tmp/team-data.json
rm -f ${json}

DATA=$( jq -n \
                --arg name "${team}" \
                --arg description  "This team is called: ${team}." \
                --arg privacy  "closed" \
                --arg repositories  "${org}/${repo}" \
                '{name: $name, description: $description, privacy: $privacy, repositories: $repositories }' )

echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/teams --data @${json_file}

rm -f ${json_file}
