.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/tags#delete-a-tag-protection-state-for-a-repository
# DELETE /repos/{owner}/{repo}/tags/protection/{tag_protection_id}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# If the script is passed an argument $1 use that as the name
if [ -z "$2" ]
  then
    tag_protection_id=${tag_protection_id}
  else
    tag_protection_id=$2
    
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/tags/protection/${tag_protection_id}
