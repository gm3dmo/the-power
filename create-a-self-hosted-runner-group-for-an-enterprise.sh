.  ./.gh-api-examples.conf

# https://docs.github.com/rest/reference/actions#create-a-self-hosted-runner-group-for-an-enterprise
# POST /enterprises/{enterprise}/actions/runner-groups

allowed_actions="all"
allows_public_repositories="false"

json_file=tmp/create-a-self-hosted-runner-group-for-an-enterprise.json
rm -f ${json_file}

jq -n \
           --arg name "${enterprise_shr_group_name}" \
           --arg allowed_actions ${allowed_actions} \
           --arg allows_public_repositories ${allows_public_repositories} \
           '{
              "name": $name,
             "allowed_actions": $allowed_actions,
             "allows_public_repositories": $allows_public_repositories | test("true")
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/runner-groups --data @${json_file}
