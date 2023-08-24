.   ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.10/rest/orgs/members?apiVersion=2022-11-28#set-organization-membership-for-a-user 
# PUT /orgs/{org}/memberships/{username}

json_file=tmp/set-organization-membership-for-a-user.json

role="member"

jq -n \
           --arg role "${role}" \
           '{
             role: $role
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}" --data @${json_file}

