.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/rules?apiVersion=2022-11-28#create-an-enterprise-repository-ruleset
# POST /enterprises/{enterprise}/rulesets

# Note: Enterprise rulesets can optionally include:
# - conditions: to scope which repositories the ruleset applies to (repository_id, repository_property)
# - bypass_actors: enterprise teams or apps that can bypass the ruleset
# Without conditions, the ruleset applies enterprise-wide.

# If the script is passed an argument $1 use that as the ruleset name
if [ -z "$1" ]
  then
    ruleset_name="enterprise_repo_ruleset1"
  else
    ruleset_name=$1
fi


json_file=tmp/create-an-enterprise-repository-ruleset.json

target=branch
enforcement=evaluate

jq -n \
           --arg name "${ruleset_name}" \
           --arg target ${target} \
           --arg commit_message_pattern $commit_message_pattern \
           --arg operator $operator \
           --arg enforcement "${enforcement}" \
           '
{
  "name": $name,
  "target": $target,
  "enforcement": $enforcement,
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


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/rulesets"  --data @${json_file}

