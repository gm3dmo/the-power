.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/webhooks?apiVersion=2022-11-28#list-repository-webhooks
# GET /repos/{owner}/{repo}/hooks


curl --silent ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/hooks"

