.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#update-an-organization
# PATCH /orgs/:org

members_can_create_repositories=${1:-true}

json_file=tmp/members-can.json
rm -f ${json_file}

jq -n \
  --arg mccr "${members_can_create_repositories}" \
  '{ "members_can_create_repositories" : $mccr | test("true") }'  > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.surtur-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org} --data @${json_file}
