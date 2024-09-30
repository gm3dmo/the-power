.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/enterprise-admin/audit-log
# GET /enterprises/{enterprise}/audit-log

# handle $1 being a user name or a user id
user_login=$1

# Use jq to extract the latest entry and add a "date_sso_response" field to the output 
# so that we can see the date of the SSO response in a human-readable format.
#
#   {
#    "@timestamp": 1727701595387,
#    "_document_id": "Ixs8jylvtY_XS6Gm-Yv1ew",
#    "action": "business.sso_response",
#    "actor": "roger-de-courcey",
#    "actor_id": 80921036,
#    "actor_is_bot": false,
#    "business": "gm3dmo-enterprise-cloud-testing",
#    "business_id": 3082,
#    "created_at": 1727701595387,
#    "external_identity_nameid": "roger-de-courcey@protonmail.com",
#    "external_identity_username": null,
#    "issuer": "http://www.okta.com/exkfj6k12Vh7IJda94x6",
#    "name": "Gm3dmo Enterprise Cloud Testing",
#    "operation_type": "authentication",
#    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
#    "date_sso_response": "2024-09-30 13:06:35" <------ Get's added by the jq command.
#   }


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?phrase=action:business.sso_response+actor:${user_login}" | jq '.[0] | .date_sso_response = (.["@timestamp"] / 1000 | strftime("%Y-%m-%d %H:%M:%S"))'

