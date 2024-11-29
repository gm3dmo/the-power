.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/secret-scanning/secret-scanning?apiVersion=2022-11-28#get-secret-scanning-scan-history-for-a-repository
# GET /repos/{owner}/{repo}/secret-scanning/scan-history


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/secret-scanning/scan-history"  
