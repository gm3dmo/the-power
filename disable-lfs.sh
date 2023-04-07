.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/lfs#disable-git-lfs-for-a-repository
# DELETE /repos/{owner}/{repo}/lfs

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


set -x
curl -v ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/lfs
