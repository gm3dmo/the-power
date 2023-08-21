.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/codespaces#create-a-codespace-for-the-authenticated-user
# POST /user/codespaces

# If the script is passed an argument $1 use that as the repo id
if [ -z "$1" ]
  then
    repository_id=$(./get-a-repo.sh ${repo} | jq -r '.id')
  else
    repository_id=$1
fi


json_file=tmp/create-codespace.json

jq -n \
           --argjson repository_id ${repository_id} \
           --arg ref "${base_branch}" \
           '{
             repository_id : $repository_id,
             ref : $ref
           }' > ${json_file}


set x
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/user/codespaces --data @${json_file}