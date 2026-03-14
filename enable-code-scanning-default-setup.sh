
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-scanning/code-scanning#update-a-code-scanning-default-setup-configuration
# PATCH /repos/{owner}/{repo}/code-scanning/default-setup

# Enable GitHub Advanced Security (required for code scanning)
ghas_json_file=tmp/enable-ghas-for-code-scanning.json

jq -n \
           '{"security_and_analysis": {"advanced_security": {"status": "enabled"}}}' > ${ghas_json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${ghas_json_file}

# Enable code scanning default setup
json_file=tmp/enable-code-scanning.json

wanted_state="configured"
query_suite="default"

jq -n \
           --arg state "${wanted_state}" \
           --arg query_suite "${query_suite}" \
           '{
             state: $state,
             query_suite : $query_suite
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/code-scanning/default-setup" --data @${json_file}
