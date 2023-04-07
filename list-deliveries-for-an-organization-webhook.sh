.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/webhooks#list-deliveries-for-an-organization-webhook
# GET /orgs/{org}/hooks/{hook_id}/deliveries

if [ -z "$1" ]
  then
    hook_id=$default_org_hook_id
  else
    hook_id=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/hooks/${hook_id}/deliveries 

