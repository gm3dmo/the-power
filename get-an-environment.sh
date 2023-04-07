.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-an-environment
# GET /repos/{owner}/{repo}/environments/{environment_name}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    environment_name=${default_environment_name}
  else
    environment_name=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/environments/${environment_name}
