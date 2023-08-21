.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/users/emails?apiVersion=2022-11-28#add-an-email-address-for-the-authenticated-user
# POST /user/emails


json_file=tmp/skeleton.json

ts=$(date +%s)
emails="test+n${ts}@example.com"

jq -n \
           --arg emails "${emails}" \
           '{
             "emails" : [ $emails ]
           }' > ${json_file}


cat $json_file | jq -r

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/user/emails  --data @${json_file}



