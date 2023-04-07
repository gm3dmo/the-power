.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/oauth-authorizations#create-a-new-authorization
# POST /authorizations

json_file=tmp/create-a-new-authorization.json

scope="repo"
client_id=${x_client_id}
note="demo create a new authorization"
note_url="https://test.com"

timestamp=$(date +%s)
fingerprint="new_auth_${timestamp}"

jq -n \
                --arg client_id "${client_id}" \
                --arg client_secret "${client_secret}" \
                --arg scopes  "${scope}" \
                --arg note "${note}" \
                --arg note_url "${note_url}" \
                --arg fingerprint "${fingerprint}" \
                '{ client_id: $client_id, client_secret: $client_secret, scopes: [ $scopes ], note: $note, note_url: $note_url, fingerprint: $fingerprint  }'  > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -u ${admin_user}:${admin_password} \
     -H "Accept: application/vnd.github.v3+json" \
        https://${hostname}/api/v3/authorizations --data @${json_file}


# This setup fails:
#                '{ client_id: $client_id, client_secret: $client_secret, scopes: [ $scopes ], note: $note, note_url: $note_url, fingerprint: $fingerprint  }'  > ${json_file}

# This set up works but the client_id is not set:

# '{ client_secret: $client_secret, scopes: [ $scopes ], note: $note, note_url: $note_url, fingerprint: $fingerprint  }'  > ${json_file}
