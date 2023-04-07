.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#list-pre-receive-hooks-for-an-organization
# GET /admin/pre-receive-hooks/:pre_receive_hook_id

if [ -z "$1" ]
  then
    pre_receive_hook_id=$pre_receive_hook_id
  else
    pre_receive_hook_id=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprise-admin/pre_receive_hooks/${pre_receive_hook_id}
