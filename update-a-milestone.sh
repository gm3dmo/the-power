.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/issues/milestones?apiVersion=2022-11-28#update-a-milestone
# PATCH /repos/{owner}/{repo}/milestones/{milestone_number}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


ts=$(date +%s)
milestone_description="Milestone description updated ${ts}"

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    milestone_number=$(./list-milestones.sh| jq '[.[].number] | max' )
  else
    milestone_number=$1
fi

json_file=tmp/update-a-milestone.json

jq -n \
           --arg description "${milestone_description}" \
           '{
             description: $description
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/milestones/${milestone_number}"  --data @${json_file}


