.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#set-organization-membership-for-a-user
# PUT /orgs/{org}/memberships/{username}

org=${1:-$org}

for person in ${org_members}
do
    #Create the user:
    json_file=tmp/${person}.json
    DATA=$( jq -n \
                  --arg pr "${person}" \
                  --arg em "${USER}+${person}@${mail_domain}" \
                  '{login : $pr, email: $em}' ) 

    echo $DATA > ${json_file}

    curl ${curl_custom_flags} \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Content-Type: application/json" \
            ${GITHUB_API_BASE_URL}/admin/users --data @${json_file}
    rm -f ${json_file}


    # Add the 'person' created to ${org}
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}
done
