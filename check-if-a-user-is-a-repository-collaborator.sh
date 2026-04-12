.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/collaborators/collaborators?apiVersion=2022-11-28#check-if-a-user-is-a-repository-collaborator
# GET /repos/{owner}/{repo}/collaborators/{username}


if [ -z "$1" ]
  then
    username=${repo_collaborator}
  else
    username=$1
fi


set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/collaborators/${username}"
