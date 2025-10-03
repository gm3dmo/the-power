.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/rules?apiVersion=2022-11-28#create-a-repository-ruleset
# POST /repos/{owner}/{repo}/rulesets


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

team_id=$(curl ${curl_custom_flags} --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

default_app_id=${app_id}

json_file=tmp/create-a-repository-ruleset.json

jq -n \
           --arg name "${ruleset_name}" \
           --arg target "${target}" \
           --arg team_id ${team_id} \
           --arg default_app_id ${default_app_id} \
           --arg commit_message_pattern $commit_message_pattern \
           --arg operator $operator \
           --arg bypass_mode "${bypass_mode}" \
           --arg enforcement "${enforcement}" \
           --argjson check_response_timeout_minutes ${check_response_timeout_minutes:-360} \
           --arg grouping_strategy "${grouping_strategy:-HEADGREEN}" \
           --argjson max_entries_to_build ${max_entries_to_build:-5} \
           --argjson max_entries_to_merge ${max_entries_to_merge:-5} \
           --arg merge_method "${merge_method:-SQUASH}" \
           --argjson min_entries_to_merge ${min_entries_to_merge:-0} \
           --argjson min_entries_to_merge_wait_minutes ${min_entries_to_merge_wait_minutes:-0} \
           '{
             name : $name,
             target : $target,
             enforcement: $enforcement,
               "bypass_actors": [
                {
                  "actor_id": $team_id | tonumber,
                  "actor_type": "Team",
		  "bypass_mode": $bypass_mode
                },
                {
                  "actor_id": $default_app_id | tonumber,
                  "actor_type": "Integration",
                  "bypass_mode": $bypass_mode
                }
              ],
             "conditions": {
              "ref_name": {
                "include": [
                  "refs/heads/main",
                  "refs/heads/master"
                ],
                "exclude": [
                  "refs/heads/dev*"
                ]
              }
            },
            "rules": [
              {
                "type": "commit_message_pattern",
                "parameters": {
                  "negate": false,
                  "pattern": $commit_message_pattern,
                  "operator": $operator 
                }
              },
              {
                "type": "merge_queue",
                "parameters": {
                  "check_response_timeout_minutes": $check_response_timeout_minutes,
                  "grouping_strategy": $grouping_strategy,
                  "max_entries_to_build": $max_entries_to_build,
                  "max_entries_to_merge": $max_entries_to_merge,
                  "merge_method": ($merge_method | ascii_upcase),
                  "min_entries_to_merge": $min_entries_to_merge,
                  "min_entries_to_merge_wait_minutes": $min_entries_to_merge_wait_minutes
                }
              }
            ]
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/rulesets"  --data @${json_file}

