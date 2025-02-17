.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.15/rest/enterprise-admin/pre-receive-hooks?apiVersion=2022-11-28#get-a-pre-receive-hook
# GET /admin/pre-receive-hooks/{pre_receive_hook_id}

if [ -z "$1" ]
  then
    pre_receive_hook_id=$pre_receive_hook_id
  else
    pre_receive_hook_id=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprise-admin/pre_receive_hooks/${pre_receive_hook_id}"

