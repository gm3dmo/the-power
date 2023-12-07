.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/copilot/copilot-for-business?apiVersion=2022-11-28#get-copilot-for-business-seat-information-and-settings-for-an-organization
# GET /orgs/{org}/copilot/billing


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/copilot/billing"
