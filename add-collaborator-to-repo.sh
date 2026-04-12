.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/collaborators/collaborators?apiVersion=2022-11-28#add-a-repository-collaborator
# PUT /repos/{owner}/{repo}/collaborators/{username}

# limits: https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    username=${repo_collaborator}
  else
    username=$1
fi

permission=${2:-push}

json_file=tmp/add-collaborator-to-repo.json

jq -n \
           --arg permission "${permission}" \
           '{
             permission : $permission,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/collaborators/${username}" --data @${json_file}

