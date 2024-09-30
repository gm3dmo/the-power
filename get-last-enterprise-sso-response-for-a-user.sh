.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/enterprise-admin/audit-log
# GET /enterprises/{enterprise}/audit-log

# handle $1 being a user name or a user id
user_login=$1


# Use jq to extract the latest entry and add a "date_sso_response" field to the output 
# so that we can see the date of the SSO response in a human-readable format.

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?phrase=action:business.sso_response+actor:${user_login}" | jq '.[0] | .date_sso_response = (.["@timestamp"] / 1000 | strftime("%Y-%m-%d %H:%M:%S"))'

