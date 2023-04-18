.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/rules?apiVersion=2022-11-28#get-all-organization-repository-rulesets
# GET /orgs/{org}/rulesets


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/rulesets"
