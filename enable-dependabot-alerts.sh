.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/repos#enable-vulnerability-alerts
# PUT /repos/{owner}/{repo}/vulnerability-alerts

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/vulnerability-alerts"
