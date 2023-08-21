.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#set-github-actions-permissions-for-an-enterprise
# PUT /enterprises/{enterprise}/actions/permissions

json_file=tmp/repo-details.json
rm -f ${json_file}


allowed_actions="all"
enabled_organizations="all"

jq -n \
           --arg enabled_organizations "${enabled_organizations}" \
           --arg allowed_actions ${allowed_actions} \
           '{
              "enabled_organizations" :  $enabled_organizations ,
             "allowed_actions" : $allowed_actions
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/permissions  --data @${json_file}
