.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/security-advisories/global-advisories?apiVersion=2026-03-10#list-global-security-advisories
# GET /advisories

curl ${curl_custom_flags} \
     -X GET \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/advisories"
