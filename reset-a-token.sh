.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/apps/oauth-applications?apiVersion=2022-11-28#reset-a-token
# PATCH /applications/{client_id}/token

json_file=tmp/reset-a-token.json

token=$1

jq -n \
       --arg access_token "${token}" \
           '{
              access_token: $access_token,
           }' > ${json_file}

curl \
     -X PATCH \
     --user "${client_id}:${app_client_secret}" \
     --header "X-GitHub-Api-Version: ${github_api_version}" \
     --url "${GITHUB_API_BASE_URL}/applications/${client_id}/token" --data @${json_file}

