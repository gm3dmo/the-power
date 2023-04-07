.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/oauth-authorizations#get-or-create-an-authorization-for-a-specific-app
# PUT /authorizations/clients/{client_id}

json_file=tmp/legacy-oauth-get-or-create-an-authorization-for-a-specific-app.json

scope="repo"
client_id=${x_client_id}
note="get or create an authorization for a specific app"
note_url="https://test.com"

jq -n \
                --arg client_secret "${client_secret}" \
                --arg scopes  "${scope}" \
                --arg note "${note}" \
                --arg note_url "${note_url}" \
                --arg fingerprint "${fingerprint}" \
                '{ client_secret: $client_secret, scopes: [ $scopes ], note: $note, note_url: $note_url, fingerprint: $fingerprint  }'  > ${json_file}

curl -L ${curl_custom_flags} \
     -X PUT \
     -u ${admin_user}:${admin_password} \
     -H "Content-type: application/json" \
     -H "Accept: application/vnd.github.v3+json" \
        https://${hostname}/api/v3/authorizations/clients/${client_id} --data @${json_file}
