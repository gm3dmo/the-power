.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-delivery-for-a-repository-webhook
# GET /repos/{owner}/{repo}/hooks/{hook_id}/deliveries/{delivery_id}

# If the script is passed an argument $1 use that as the hook_id
if [ -z "$1" ]
  then
   # we get the first delivery_id the list repo here:
   hook_id=$(./list-repo-webhooks.sh | jq -r '.[0] .id')
   echo "hook_id: $hook_id"
   delivery_id=$(./list-deliveries-for-repository-webhook.sh | jq -r '.[0] .id')
  else
   hook_id=$1
   delivery_id=$2
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks/${hook_id}/deliveries/${delivery_id}
