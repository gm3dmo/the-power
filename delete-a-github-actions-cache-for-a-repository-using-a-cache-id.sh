.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/cache?apiVersion=2022-11-28#delete-a-github-actions-cache-for-a-repository-using-a-cache-id
# DELETE /repos/{owner}/{repo}/actions/caches/{cache_id}

# If the script is passed an argument $1 use that as the cache_id
if [ -z "$1" ]
  then
    cache_id=$(./list-github-actions-caches-for-a-repository.sh | jq -r '.actions_caches[-1].id')
  else
    cache_id=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/caches/${cache_id}"
