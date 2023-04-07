.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#delete-an-environment
# DELETE /repos/{owner}/{repo}/environments/{environment_name}



# If the script is passed an argument $1 use that as the branch
if [ -z "$1" ]
  then
    environment_name="environment_1"
  else
    environment_name=${1}
fi

# If the script is passed an argument $2 use that as the name of the repo
if [ -z "$2" ]
  then
    repo=$repo
  else
    repo=$2
fi


curl ${curl_custom_flags} \
  -X DELETE \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/environments/${environment_name}
