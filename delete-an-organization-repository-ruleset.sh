.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/rules?apiVersion=2022-11-28#delete-an-organization-repository-ruleset
# DELETE /orgs/{org}/rulesets/{ruleset_id}


if [ -z "$1" ]
  then
    ruleset_id=$(./get-all-organization-repository-rulesets.sh | jq -r '[.[].id] | max ')
  else
    ruleset=$1
fi

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/rulesets/${ruleset_id}"

