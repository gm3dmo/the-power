.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#delete-a-release
# DELETE /repos/{owner}/{repo}/releases/{release_id}


# If the script is passed an argument $1 use that as the release_id
if [ -z "$1" ]
  then
    release_id=$(./list-releases.sh | jq -r 'last.id')
  else
    release_id=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/releases/${release_id}"
