.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/webhooks?apiVersion=2022-11-28#delete-an-organization-webhook
# DELETE /orgs/{org}/hooks/{hook_id}


if [ -z "$1" ]
  then
    hook_id=$(./list-organization-webhooks.sh  jq '.[-1].id')
  else
    hook_id=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/hooks/${hook_id}"

