.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#add-user-access-restrictions
# POST /repos/{owner}/{repo}/branches/{branch}/protection/restrictions/users

branch=${protected_branch_name}

if [ -z "$1" ]
  then
    username="${team_admin}"
  else
    username=$1
fi

json_file=tmp/post-add-user-access-restrictions.json
jq -n \
       --arg username "${username}" \
       '{
         users: [ $username ]
       }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/restrictions/users" --data @${json_file}
