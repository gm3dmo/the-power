.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/rules?apiVersion=2022-11-28#get-an-organization-repository-ruleset
# GET /orgs/{org}/rulesets/{ruleset_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ruleset_id=$(./get-all-organization-repository-rulesets.sh | jq '[.[].id] | max')
  else
    rulset_id=%1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/rulesets/${ruleset_id}"

