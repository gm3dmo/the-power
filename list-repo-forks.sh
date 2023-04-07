.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#list-forks
# GET /repos/{owner}/{repo}/forks

# If the script is passed an argument $1 use that as repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


# If the script is passed an argument $3 use that as the org
if [ -z "$2" ]
  then
    org=${org}
  else
    org=${2}
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/forks
