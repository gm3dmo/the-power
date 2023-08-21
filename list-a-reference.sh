.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#get-a-reference
# GET /repos/{owner}/{repo}/git/ref/{ref}


# If the script is passed an argument $1 use that as the ref
if [ -z "$1" ]
  then
    ref="heads/$base_branch"
  else
    ref="heads/$1"
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/${ref}
