.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/branches/branch-protection?apiVersion=2022-11-28#get-branch-protection
# GET /repos/{owner}/{repo}/branches/{branch}/protection


if [ -z "$1" ]
  then
    branch=${base_branch}
  else
    branch=$1
fi

curl  ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection"

