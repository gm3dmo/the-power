.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/branches/branch-protection?apiVersion=2022-11-28#set-team-access-restrictions
# PUT /repos/{owner}/{repo}/branches/{branch}/protection/restrictions/teams


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

branch=${protected_branch_name}

json_file=tmp/skeleton.json

jq -n \
           --arg team_slug "${team_slug}" \
           '{
             teams: [ $team_slug ]
           }' > ${json_file}



curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/branches/${branch}/protection/restrictions/teams"  --data @${json_file}
