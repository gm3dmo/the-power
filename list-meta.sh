.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/meta/meta?apiVersion=2022-11-28#get-github-enterprise-server-meta-information
# GET /meta


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/meta"

