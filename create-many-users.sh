.  ./.gh-api-examples.conf

# Depends on `generate-long-list-of-people.pl` having run to create $people_file.

people_file=tmp/longlistofpeople.txt
head -${number_of_users_to_create_on_ghes} test-data/NAMES.TXT > ${people_file}

TESTNAME="crt-mny-usrs"

for person in `cat ${people_file}`
do
    DATA=$( jq -n \
                  --arg pr "${person}" \
                  --arg em "${USER}+${person}@${mail_domain}" \
                  '{login : $pr, email: $em}' ) 

    echo $DATA > tmp/${person}

    curl --user-agent ${TESTNAME}-${person} ${curl_custom_flags} \
         -X POST \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/admin/users --data @tmp/${person}
done

