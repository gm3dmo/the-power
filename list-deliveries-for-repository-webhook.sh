.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/webhooks?apiVersion=2022-11-28#list-deliveries-for-a-repository-webhook
# GET /repos/{owner}/{repo}/hooks/{hook_id}/deliveries


# If the script is passed an argument $1 use that as the hook_id
if [ -z "$1" ]
  then
   # we only get the first hook in the list repo here:
   hook_id=$(./list-repo-webhooks.sh | jq -r '.[0] .id')
  else
   hook_id=$1
fi


curl --silent ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks/${hook_id}/deliveries
