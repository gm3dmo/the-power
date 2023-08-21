.  ./.gh-api-examples.conf

for collaborator in ${collaborators}
do
    DATA=$( jq -n \
                  --arg login "${collaborator}" \
                  --arg email "${USER}+${collaborator}@${mail_domain}" \
                  '{login : $login, email: $email}' ) 

    echo $DATA > tmp/${collaborator}

    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/admin/users --data @tmp/${collaborator} 
    rm -f tmp/${collaborator}
done
