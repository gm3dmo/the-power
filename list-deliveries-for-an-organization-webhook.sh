.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/webhooks?apiVersion=2022-11-28#list-deliveries-for-an-organization-webhook
# GET /orgs/{org}/hooks/{hook_id}/deliveries


if [ -z "$1" ]
  then
    hook_id=${default_org_hook_id}
  else
    hook_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/hooks/${hook_id}/deliveries"

