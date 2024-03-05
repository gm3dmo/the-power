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

json_file=tmp/create-a-repository-ruleset.json

enforcement=active



jq -n \
           --arg name "the-power-branch-allow-github-app-override" \
           --arg target "branch" \
           --arg default_app_id ${default_app_id} \
           --arg bypass_mode "${bypass_mode}" \
           --arg enforcement "${enforcement}" \
           --arg source "${owner}/${repo}" \
           '{
             name : $name,
             target : $target,
             "source_type": "Repository",
             "source": $source,
             enforcement: $enforcement,

             "conditions": {
               "ref_name": {
                 "exclude": [
           
                 ],
                 "include": [
                   "~DEFAULT_BRANCH"
                 ]
               }
             },
             "rules": [
               {
                 "type": "deletion"
               },
               {
                 "type": "non_fast_forward"
               },
               {
                 "type": "creation"
               },
               {
                 "type": "update"
               }
             ],

           "bypass_actors": [
             {
               "actor_id": $default_app_id | tonumber,
               "actor_type": "Integration",
               "bypass_mode": "always"
             },
             {
               "actor_id": 1,
               "actor_type": "OrganizationAdmin",
               "bypass_mode": "always"
             }


           ],


           }' > ${json_file}

cat $json_file | jq -r
#exit


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/rulesets"  --data @${json_file}

