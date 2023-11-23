.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/rules?apiVersion=2022-11-28#get-a-repository-ruleset
# GET /repos/{owner}/{repo}/rulesets/{ruleset_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ruleset_id=$(./get-all-repository-rulesets.sh | jq -r '.[-1].id')
  else
    ruleset_id=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/rulesets/${ruleset_id}"

