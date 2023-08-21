.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#delete-a-reference
# DELETE /repos/{owner}/{repo}/git/refs/{ref}

#refs/heads/grandmasterflash2

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# If the script is passed an argument $1 use that as the ref
if [ -z "$2" ]
  then
    ref="refs/heads/$ref"
  else
    ref="refs/heads/$2"
fi

set -x
curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/${ref}
