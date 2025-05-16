.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/releases/assets?apiVersion=2022-11-28#delete-a-release-asset
# DELETE /repos/{owner}/{repo}/releases/assets/{asset_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    asset_id=$(./list-release-assets.sh | jq '[.[].id] | max')
  else
    asset_id=$1
fi


set -x
curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/releases/assets/${asset_id}"

