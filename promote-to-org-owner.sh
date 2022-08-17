. .gh-api-examples.conf

for person in ${org_owner}

do
    DATA=$( jq -n \
                  --arg role "admin" \
                  '{ role : $role}')

    echo $DATA > tmp/${person}

    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: token ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person} --data @tmp/${person}
done

rm -f tmp/${person}
