.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/orgs/members?apiVersion=2022-11-28#set-organization-membership-for-a-user
# PUT /orgs/{org}/memberships/{username}


for person in ${org_owner}

do
    DATA=$( jq -n \
                  --arg role "admin" \
                  '{ role : $role}')

    echo $DATA > tmp/${person}

    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person} --data @tmp/${person}
done

rm -f tmp/${person}
