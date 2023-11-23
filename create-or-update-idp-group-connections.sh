.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/teams/team-sync?apiVersion=2022-11-28#create-or-update-idp-group-connections
# PATCH /orgs/{org}/teams/{team_slug}/team-sync/group-mappings


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


ts=$(date +'%s')
json_file=tmp/create-or-update-idp-group-connections.json

group_id="1ea6bb94-69ff-4bd2-a495-5c4d90bb72ce"
group_name="read-only-team powertest ${ts}"
group_description="description test1 ${ts}"


jq -n \
           --arg group_id "${group_id}" \
           --arg group_name "${group_name}" \
           --arg group_description "${group_description}" \
           '{groups: [ {
             group_id : $group_id,
             group_name : $group_name,
             group_description  : $group_description,
           } ]}' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/teams/${team_slug}/team-sync/group-mappings"  --data @${json_file}

