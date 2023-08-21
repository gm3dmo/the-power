.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#list-pending-organization-invitations
# GET /orgs/{org}/invitations

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/invitations
