.  ./.gh-api-examples.conf

json_file=tmp/orgData
rm -f ${json_file}

DATA=$( jq -n \
                --arg nm "$org" \
                --arg pn  "A Test Organization." \
                --arg ad  "${admin_user}" \
                '{login: $nm, profile_name: $pn, admin: $ad}' )

echo $DATA > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/organizations --data @${json_file}

rm -f ${json_file}
