.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#delete-branch-protection
# DELETE /repos/{owner}/{repo}/branches/{branch}/protection


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

branch=${protected_branch_name}

set -x
curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/branches/${branch}/protection"

