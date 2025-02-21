.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/orgs?apiVersion=2022-11-28#update-an-organization
# PATCH /orgs/{org}


members_can_create_repositories=${1:-true}


json_file=tmp/members-can.json

jq -n \
  --arg members_can_create_repositories "${members_can_create_repositories}" \
  '{ "members_can_create_repositories" : $members_can_create_repositories | test("true") }'  > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}" --data @${json_file}

