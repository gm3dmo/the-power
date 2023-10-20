.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-branch
# GET /repos/{owner}/{repo}/branches/{branch}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    branch=${base_branch}
  else
    branch=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}


