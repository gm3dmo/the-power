.  ./.gh-api-examples.conf

# Create plain users These are not members an org or of a team.
# Useful to test privileges.


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
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/users --data @${json_file}

    rm -f ${json_file}
done
