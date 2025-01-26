.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/webhooks?apiVersion=2022-11-28#create-an-organization-webhook
# POST /orgs/{org}/hooks

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

json_file=tmp/create-an-organization-webhook-with-secret.json

jq -n \
        --arg name "web" \
        --arg webhook_url "${webhook_url}" \
        --arg content "json" \
        --arg scret "" \
        '{
           name: $name,
           secret: $name,
           active: true,
           events: [
             "organization",
	     "repository"
           ],
           config: {
             url: $webhook_url,
             content_type: $content,
             insecure_ssl: "0"
           }
         }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/hooks" --data @${json_file}




