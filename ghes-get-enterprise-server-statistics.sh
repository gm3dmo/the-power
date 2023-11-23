.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/admin-stats?apiVersion=2022-11-28#get-github-enterprise-server-statistics
# GET /enterprise-installation/{enterprise_or_org}/server-statistics


set -x
curl -v ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/enterprise-installation/${enterprise}/server-statistics 
