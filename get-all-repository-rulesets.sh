.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/rules?apiVersion=2022-11-28#get-all-repository-rulesets
# GET /repos/{owner}/{repo}/rulesets


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/rulesets
