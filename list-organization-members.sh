.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/members?apiVersion=2022-11-28#list-organization-members
# GET /orgs/{org}/members

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/members"
