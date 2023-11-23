.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/meta#get-github-enterprise-server-meta-information
# GET /meta

curl --silent \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/meta" | jq -r '.installed_version'
