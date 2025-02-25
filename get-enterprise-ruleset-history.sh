.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/rules?apiVersion=2022-11-28#get-enterprise-ruleset-history
# GET /enterprises/{enterprise}/rulesets/{ruleset_id}/history


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ruleset_id=$()
  else
    ruleset_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/rulesets/${ruleset_id}/history"

