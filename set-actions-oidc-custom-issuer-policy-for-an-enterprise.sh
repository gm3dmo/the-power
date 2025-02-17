.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc?apiVersion=2022-11-28#set-the-github-actions-oidc-custom-issuer-policy-for-an-enterprise
# PUT /enterprises/{enterprise}/actions/oidc/customization/issuer


# You must authenticate using an access token with the admin:enterprise scope to use this endpoint. 

# Use $1 or "true" as a default of no argument is provided.
include_enterprise_slug=${1:-true}

json_file=tmp/set-actions-oidc-custom-issuer-policy-for-an-enterprise.json
jq -n \
       --arg include_enterprise_slug "${include_enterprise_slug}" \
           '{
             include_enterprise_slug: $include_enterprise_slug | test("true")
           }' > ${json_file}


    curl ${curl_custom_flags} \
        -X PUT \
        -H "X-GitHub-Api-Version: ${github_api_version}" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
           "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/oidc/customization/issuer"  --data @${json_file}
