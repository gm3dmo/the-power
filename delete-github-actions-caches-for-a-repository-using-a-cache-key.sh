.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/cache?apiVersion=2022-11-28#delete-github-actions-caches-for-a-repository-using-a-cache-key
# DELETE /repos/{owner}/{repo}/actions/caches?key={key}

# If the script is passed an argument $1 use that as the cache key
if [ -z "$1" ]
  then
    cache_key=$(./list-github-actions-caches-for-a-repository.sh | jq -r '.actions_caches[-1].key')
  else
    cache_key=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/caches?key=${cache_key}"
