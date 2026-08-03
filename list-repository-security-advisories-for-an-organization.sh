.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/security-advisories/repository-advisories?apiVersion=2026-03-10#list-repository-security-advisories-for-an-organization
# GET /orgs/{org}/security-advisories

curl ${curl_custom_flags} \
     -X GET \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/security-advisories"
