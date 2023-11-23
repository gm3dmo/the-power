.  ./.gh-api-examples.conf

# https://docs.github.com/en/free-pro-team@latest/rest/git/trees?apiVersion=2022-11-28#get-a-tree
# GET /repos/{owner}/{repo}/git/trees/{tree_sha}

if [ -z "$1" ]
  then
    tree_sha=""
  else
    tree_sha=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/trees/${tree_sha}
