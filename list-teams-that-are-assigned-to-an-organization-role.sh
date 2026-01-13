.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/organization-roles?apiVersion=2022-11-28#list-teams-that-are-assigned-to-an-organization-role
# GET /orgs/{org}/organization-roles/{role_id}/teams


role_id=$1

set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/organization-roles/${role_id}/teams"

