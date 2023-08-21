.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#get-the-audit-log-for-an-organization
# GET /orgs/{org}/audit-log

phrase="action:repo.rename"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/audit-log?phrase=${phrase}"
