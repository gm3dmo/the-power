.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#set-organization-membership-for-a-user
# PUT /orgs/:org/memberships/:username
#
TESTNAME="prmt-mny-usrs"

for person in $(cat tmp/longlistofpeople.txt)
do
    DATA=$( jq -n \
                  --arg role "admin" \
                  '{ role : $role}')

    echo $DATA > tmp/${person}
    curl --user-agent ${TESTNAME}-${person} ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person} --data @tmp/${person}
done
