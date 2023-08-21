.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/self-hosted-runner-groups#set-repository-access-for-a-self-hosted-runner-group-in-an-organization
# PUT /orgs/{org}/actions/runner-groups/{runner_group_id}/repositories

# If the script is passed arguments, use them as the repo ids to add to the runner group.

if [ -z "$@" ]
  then
    repos=$(./list-org-repos.sh | jq '.[1] .id')
  else
    repos=`echo $@ | sed s/" "/,/g | cut -d "," -f1-`
fi

json_file=tmp/selected_repo_ids.json
runner_group_id=$(./list-self-hosted-runner-groups-for-an-organization.sh | jq -r '.runner_groups[0].id')

# Use JQ to build an array of repository ids to add to the runner group.

jq -n \
           --arg repo_ids "${repos}" \
           '{
             selected_repository_ids : $repo_ids | split(",") | map(tonumber),
           }' > ${json_file}

# Send the request to add the repos to the runner group.

curl -X PUT -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/actions/runner-groups/${runner_group_id}/repositories --data @${json_file}