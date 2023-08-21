.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/custom-roles#list-custom-repository-roles-in-an-organization
# GET /organizations/{organization_id}/custom_roles

organization_id=$(./list-organization.sh | jq -r '.id')

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/organizations/${organization_id}/custom_roles
