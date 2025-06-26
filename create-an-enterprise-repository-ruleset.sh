.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/rules?apiVersion=2022-11-28#create-an-enterprise-repository-ruleset
# post /enterprises/{enterprise}/rulesets


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    enterprise=${enterprise}
  else
    enterprise=$1
fi

target="repository"
enforcement="active"

actor_id=$(curl ${curl_custom_flags} -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/teams/$team_slug | jq '.id')
actor_type="Team"
bypass_mode="always"
rules_type="repository_delete"

org_include=$(./list-organization.sh | jq -r '.id')
#org_exclude=$(./list-organization.sh pulepule | jq -r '.id')


json_file=tmp/create-an-enterprise-repository-ruleset.json
jq -n \
           --arg name "${ent_repo_ruleset_name}" \
           --arg repo "${repo}" \
           --arg target "${target}" \
           --arg enforcement "${enforcement}" \
           --argjson org_include "${org_include}" \
           --argjson actor_id "${actor_id}" \
           --arg actor_type "${actor_type}" \
           --arg bypass_mode "${bypass_mode}" \
           --arg rules_type "${rules_type}" \
           '{
             name : $name,
             target : $target,
             enforcement: $enforcement,
             bypass_actors: [ { actor_id: $actor_id, actor_type: $actor_type, bypass_mode: $bypass_mode } ],
             conditions: {organization_id: {include:[$org_include], repository_name: ["*"] }},
             rules: [ {type: $rules_type} ]
           }' > ${json_file}

cat $json_file | jq -r

echo "This script doesn't work yet"
exit

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/rulesets"  --data @${json_file}

