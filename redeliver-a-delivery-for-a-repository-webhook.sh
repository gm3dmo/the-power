.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/webhooks?apiVersion=2022-11-28#redeliver-a-delivery-for-a-repository-webhook
# POST /repos/{owner}/{repo}/hooks/{hook_id}/deliveries/{delivery_id}/attempts


if [ -z "$1" ]
  then
    echo "Please pass delivery_id to the script"
  else
    delivery_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/{owner}/{repo}/hooks/{hook_id}/deliveries/{delivery_id}/attempts"

