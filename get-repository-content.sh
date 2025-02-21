.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/contents?apiVersion=2022-11-28#get-repository-content
# GET /repos/{owner}/{repo}/contents/{path}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    path="docs/README.md"
  else
    path=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/contents/${path}"
