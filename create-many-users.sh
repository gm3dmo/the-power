. .gh-api-examples.conf

# Depends on `generate-long-list-of-people.pl` having run to create $people_file.

people_file=tmp/longlistofpeople.txt
head -${count_of_users_to_add_to_ghes} test-data/NAMES.TXT > ${people_file}


for person in `cat ${people_file}`
do
    DATA=$( jq -n \
                  --arg pr "${person}" \
                  --arg em "${USER}+${person}@${mail_domain}" \
                  '{login : $pr, email: $em}' ) 

    echo $DATA > tmp/${person}

    echo curl ${curl_custom_flags} \
         -X POST \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: token ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/admin/users --data @tmp/${person} 
    rm -f tmp/${person}
done

