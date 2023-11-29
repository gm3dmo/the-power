.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/projects/cards?apiVersion=2022-11-28#create-a-project-card
# POST /projects/columns/{column_id}/cards


json_file=tmp/create-a-project-card.json

column_id=6

content_id=1
content_type="Issue"


jq -n \
           --arg content_id ${content_id} \
           --arg content_type "${content_type}" \
           '{
             content_id: $content_id | tonumber,
             content_type: $content_type
           }' > ${json_file}

cat $json_file | jq -r


set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/projects/columns/${column_id}/cards"  --data @${json_file}
