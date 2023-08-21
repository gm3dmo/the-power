.  ./.gh-api-examples.conf

people_file=tmp/longlistofpeople.txt
head -${number_of_users_to_create_on_ghes} test-data/NAMES.TXT > ${people_file}
nl $people_file

for team_member in $(cat ${people_file})
do
    DATA=$( jq -n \
                  --arg pr "${team_member}" \
                  --arg em "${USER}+${team_member}@${mail_domain}" \
                  '{login : $pr, email: $em}' )

    echo $DATA > tmp/${team_member}

    curl ${curl_custom_flags} \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Content-Type: application/json" \
            ${GITHUB_API_BASE_URL}/admin/users --data @tmp/${team_member} 

    rm -f tmp/${team_member}
done
