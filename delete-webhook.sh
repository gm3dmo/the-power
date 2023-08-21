.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#delete-a-repository-webhook
# DELETE /repos/{owner}/{repo}/hooks/{hook_id}


if [ -z "$1" ]
  then
    hook_id=1
  else
    hook_id=$1
fi

if [ -z "$2" ]
  then
    repo=${repo}
  else
    repo=$2
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks/${hook_id}
