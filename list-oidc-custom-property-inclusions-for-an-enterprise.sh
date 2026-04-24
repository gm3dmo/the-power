.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#list-oidc-custom-property-inclusions-for-an-enterprise
# GET /enterprises/{enterprise}/actions/oidc/customization/properties/repo

# You must authenticate using an access token with the admin:enterprise scope to use this endpoint.


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/oidc/customization/properties/repo"
