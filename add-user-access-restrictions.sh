.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#add-user-access-restrictions
# PUT /repos/{owner}/{repo}/branches/{branch}/protection/restrictions/users 


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    username="pipcripsy"
  else
    username=$1
fi

json_file="tmp/add-user-access-restrictions"

jq -n \
           --arg username "${username}" \
           '{
             users: [ $username ] 
           }' > ${json_file}


cat $json_file | jq -r 

branch=${protected_branch_name}



set -x

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/branches/${branch}/protection/restrictions/users"  --data @${json_file}

