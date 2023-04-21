.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/rules?apiVersion=2022-11-28#create-an-organization-repository-ruleset
# POST /orgs/{org}/rulesets


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


json_file=tmp/skeleton.json

ruleset_name=org_repo_ruleset1
target=branch
enforcement=evaluate

#  -d '{"id":21,"name":"super cool ruleset","target":"branch","enforcement":"enabled","bypass_actors":[{"actor_id":234,"actor_type":"Team"}],"conditions":{"ref_name":{"include":["refs/heads/main","refs/heads/master"],"exclude":["refs/heads/dev*"]}},"rules":[{"type":"commit_author_email_pattern","parameters":{"operator":"contains","pattern":"github"}}]}'

# 1. For enforcement the example in the docs link above is "enabled"
# When submitted with "enabled":
#
# {
#   "message": "Invalid request.\n\nInvalid property /enforcement: `enabled` is not a possible value. Must be one of the following: disabled, active, evaluate.",
#   "documentation_url": "https://docs.github.com/rest/repos/rules#create-organization-repository-ruleset"
# }
#

# 2. Pretty certain that "id" is not required when posting to create a new
# ruleset.


jq -n \
           --arg name "${ruleset_name}" \
           --arg target "${target}" \
           --arg enforcement "${enforcement}" \
           '{
             name : $name,
             target : $target,
             enforcement: $enforcement,
               "bypass_actors": [
                {
                  "actor_id": 234,
                  "actor_type": "Team"
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
                        "type": "commit_author_email_pattern",
                        "parameters": {
                          "operator": "contains",
                          "pattern": "github"
                        }
                      }
            ]
           }' > ${json_file}



curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/rulesets"  --data @${json_file}
