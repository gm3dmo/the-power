.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/orgs#create-an-organization
# POST /admin/organizations

org=${1:-$org}
json_file=tmp/organization-data.json
rm -f ${json_file}

DATA=$( jq -n \
                --arg nm "$org" \
                --arg pn "${org}: A Test Organization." \
                --arg ad "${admin_user}" \
                '{login: $nm, profile_name: $pn, admin: $ad}' )

echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/organizations --data @${json_file}

rm -f ${json_file}
