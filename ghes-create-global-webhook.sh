.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/global-webhooks#create-a-global-webhook
# POST /admin/hooks


if [ -z $global_webhook]; then
  global_webhook_url=${webhook_url}
fi


json_file=tmp/ghes-create-global-webhook.json
rm -f ${json_file}

jq -n \
        --arg name "web" \
        --arg webhook_url "${global_webhook_url}" \
        --arg ct "json" \
        '{
           name: $name,
           active: true,
           events: [
             "repository",
             "member",
             "fork",
             "ping"
           ],
           config: {
             url: $webhook_url,
             content_type: $ct,
             insecure_ssl: "0"
           }
         }' > ${json_file}

cat $json_file | jq -r


curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks --data @${json_file}
