.  ./.gh-api-examples.conf

# [!] This only works on GitHub Enterprise Cloud.
# https://docs.github.com/en/rest/scim#list-scim-provisioned-identities
# GET /scim/v2/organizations/{org}/Users

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/scim/v2/organizations/${org}/Users
