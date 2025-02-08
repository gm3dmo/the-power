.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#set-organization-membership-for-a-user
# PUT /orgs/{org}/memberships/{username}


if [ -z "$1" ]
  then
    org=${org}
  else
    org=$1
fi


for person in ${org_members}
do
    #Create the user:
    json_file=tmp/$set-organization-membership-for-a-user-{person}.json
    email="${USER}+${person}@${mail_domain}" 

    jq -n \
           --arg login "${person}" \
           --arg email "${email}" \
           '{
             login: $login,
             email: $email
           }' > ${json_file}

    
    # Create the person as a user
    curl ${curl_custom_flags} \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Content-Type: application/json" \
            "${GITHUB_API_BASE_URL}/admin/users" --data @${json_file}


    # Add the 'person' created to ${org}
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}"
done

