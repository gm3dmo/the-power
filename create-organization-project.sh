.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/projects#create-an-organization-project
# POST /orgs/:org/projects

json_file=tmp/project-details.json
rm -f ${json_file}

DATA=$(jq -n \
                  --arg nm "${org}-project" \
                  --arg bd "${org} things to manage." \
                  '{name : $nm, body: $bd}')
echo ${DATA} > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.inertia-preview+json"  \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         ${GITHUB_API_BASE_URL}/orgs/${org}/projects --data @${json_file}

rm -f ${json_file}
