.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/collaborators/collaborators?apiVersion=2022-11-28#remove-a-repository-collaborator
# DELETE /repos/{owner}/{repo}/collaborators/{username}

if [ -z "$1" ]
  then
    username=${default_collaborator}
  else
    username=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/collaborators/${username}

