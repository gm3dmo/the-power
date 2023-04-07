.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#enable-git-lfs-for-a-repository
# PUT /repos/{owner}/{repo}/lfs

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


# If the script is passed an argument $2 use that as the org
if [ -z "$2" ]
  then
    org=${org}
  else
    org=${2}
fi


set -x
curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/lfs
