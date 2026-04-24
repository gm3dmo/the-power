.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#list-oidc-custom-property-inclusions-for-an-organization
# GET /orgs/{org}/actions/oidc/customization/properties/repo

# You must authenticate using an access token with the read:org scope to use this endpoint.

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/oidc/customization/properties/repo"
