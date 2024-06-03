.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/rules?apiVersion=2022-11-28#update-an-organization-repository-ruleset
# PUT /orgs/{org}/rulesets/{ruleset_id}

json_file=tmp/update-an-organization-repository-ruleset.json


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ruleset_id=$(./get-all-organization-repository-rulesets.sh | jq '[.[].id] | max')
  else
    rulset_id=$1
fi

ruleset_name=org_repo_ruleset1
target=branch
enforcement=evaluate

team_id=$(curl ${curl_custom_flags} --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')

json_file=tmp/create-a-repository-ruleset.json

jq -n \
           --arg name "${ruleset_name}" \
           --arg target ${target} \
           --arg team_id ${team_id} \
           --arg default_app_id ${default_app_id} \
           --arg commit_message_pattern $commit_message_pattern \
           --arg operator $operator \
           --arg bypass_mode "${bypass_mode}" \
           --arg enforcement "${enforcement}" \
           --arg included_repo "${repo}" \
           '
{
  "name": $name,
  "target": $target,
  "enforcement": $enforcement,
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
    },
    "repository_name": {
      "include": [
        $included_repo
      ],
      "exclude": [
        "excluded_repo"
      ],
      "protected": true
    }
  },
  "rules": [
    {
      "type": "commit_message_pattern",
      "parameters": {
        "operator": $operator,
        "pattern": $commit_message_pattern
      }
    }
  ]
}
' > ${json_file}


set -x
curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/rulesets/${ruleset_id}"  --data @${json_file}

