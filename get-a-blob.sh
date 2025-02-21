.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/blobs?apiVersion=2022-11-28#get-a-blob
# GET /repos/{owner}/{repo}/git/blobs/{file_sha}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    # This is getting the default file for get-repository-content.sh you'll need to change it if you want a different file.
    file_sha=$(./get-repository-content.sh | jq -r '.sha')
  else
    file_sha=$1
fi


curl -L ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/git/blobs/${file_sha}"  

