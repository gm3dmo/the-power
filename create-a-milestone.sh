.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/issues/milestones?apiVersion=2022-11-28#create-a-milestone
# POST /repos/{owner}/{repo}/milestones


# If the script is passed an argument $1 use that as the title
if [ -z "$1" ]
  then
    milestone_title="pwr-milestone-1"
  else
    milestone_title=$1
fi


milestone_description="power milestone description"
milestone_state="open"
milestone_due_on="today+30"
#YYYY-MM-DDTHH:MM:SSZ
milestone_due_on="2026-01-31T00:00:00Z"

json_file="tmp/create-a-milestone"

jq -n \
           --arg title "${milestone_title}" \
           --arg description "${milestone_description}" \
           --arg state "${milestone_state}" \
           --arg due_on "${milestone_due_on}" \
           '{
             title: $title,
             description: $description,
             state: $state,
             due_on: $due_on
           }' > ${json_file}

cat $json_file | jq -r 

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/milestones" -d @${json_file}

