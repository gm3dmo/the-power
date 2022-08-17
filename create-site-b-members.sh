. .gh-api-examples.conf

# Create org members. These are not members of a team.
# Useful to test privileges.

org=${1}

for person in ${plain_users}
do
    #Create the user:
    json_file=tmp/${person}.json
    DATA=$( jq -n \
                  --arg pr "${person}" \
                  --arg em "${USER}+${person}@${mail_domain}" \
                  '{login : $pr, email: $em}' ) 

    echo $DATA > ${json_file}

    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: token ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/admin/users --data @${json_file}
    rm -f ${json_file}

    # Add the 'person' created to ${org}
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: token ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}
done
