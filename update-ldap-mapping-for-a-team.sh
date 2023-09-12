.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.6/rest/enterprise-admin/ldap#update-ldap-mapping-for-a-team
# PATCH /admin/ldap/teams/{team_id}/mapping

team_id=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

json_file=tmp/update-ldap-mapping-for-a-team.json

jq -n \
           --arg ldap_dn "${ldap_dn}" \
           '{
             ldap_dn : $ldap_dn,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/admin/ldap/teams/${team_id}/mapping"  --data @${json_file}

