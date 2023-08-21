.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.5/rest/git/tags#get-a-tag
# GET /repos/{owner}/{repo}/git/tags/{tag_sha}

if [ -z "$1" ]
  then
    tag_sha=${default_tag_sha}
  else
    tag_sha=$1
fi


set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/tags/${tag_sha}


