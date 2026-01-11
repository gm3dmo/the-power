.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/rules?apiVersion=2022-11-28#get-an-enterprise-repository-ruleset
# GET /enterprises/{enterprise}/rulesets/{ruleset_id}


# If the script is passed an argument $1 use that as the ruleset_id
if [ -z "$1" ]
  then
    echo "Error: ruleset_id is required as first argument"
    exit 1
  else
    ruleset_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/rulesets/${ruleset_id}"
