.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/external-groups?apiVersion=2022-11-28#get-an-external-group
# GET /orgs/{org}/external-group/{group_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
   group_id=1
  else
    group_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/external-group/${group_id}"  --data @${json_file}
