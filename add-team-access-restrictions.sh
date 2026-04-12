.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#add-team-access-restrictions
# POST /repos/{owner}/{repo}/branches/{branch}/protection/restrictions/teams

branch=${protected_branch_name}

json_file=tmp/add-team-access-restrictions.json
jq -n \
       --arg team_slug "${team_slug}" \
       '{
         teams: [ $team_slug ]
       }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/restrictions/teams" --data @${json_file}
