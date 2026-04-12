.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/branches/branches?apiVersion=2022-11-28#rename-a-branch
# POST /repos/{owner}/{repo}/branches/{branch}/rename

if [ -z "$1" ]
  then
    branch=${base_branch}
  else
    branch=$1
fi

if [ -z "$2" ]
  then
    new_name="${branch}-renamed"
  else
    new_name=$2
fi

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/rename" \
        -d "{\"new_name\":\"${new_name}\"}"
