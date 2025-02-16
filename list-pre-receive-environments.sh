.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin?apiVersion=2022-11-28#list-pre-receive-environments
# GET /admin/pre-receive-environments


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/admin/pre-receive-environments"

