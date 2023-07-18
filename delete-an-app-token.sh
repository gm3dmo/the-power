.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/apps/oauth-applications?apiVersion=2022-11-28#delete-an-app-token
# DELETE /applications/{client_id}/token
#

token_to_delete=$1

json_file=tmp/delete-an-app-token.json

jq -n \
       --arg access_token "${token_to_delete}" \
           '{
              access_token: $access_token,
           }' > ${json_file}

curl \
     -X DELETE \
     --user "${client_id}:${app_client_secret}" \
     --header "X-GitHub-Api-Version: ${github_api_version}" \
     --url "${GITHUB_API_BASE_URL}/applications/${client_id}/token" --data @${json_file}
