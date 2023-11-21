.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#get-a-release-by-tag-name
# GET /repos/{owner}/{repo}/releases/tags/{tag}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    tag=$tag
  else
    tag=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/releases/tags/${tag}"
