.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/scim/scim?apiVersion=2022-11-28#list-scim-provisioned-identities
# GET /scim/v2/organizations/{org}/Users
# [!] This only works on GitHub Enterprise Cloud.
# Not known why it has a capital U for Users in the url


curl -v ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/scim/v2/organizations/${org}/Users"

