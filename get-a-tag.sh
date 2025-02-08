.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/tags?apiVersion=2022-11-28#get-a-tag
# GET /repos/{owner}/{repo}/git/tags/{tag_sha}

if [ -z "$1" ]
  then
    tag_sha=$(./list-repo-tags.sh  | jq -r '[.[].commit.sha] | max')
  else
    tag_sha=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/tags/${tag_sha}"

