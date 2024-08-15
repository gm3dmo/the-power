.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-security/configurations?apiVersion=2022-11-28#create-a-code-security-configuration
# POST /orgs/{org}/code-security/configurations

json_file=tmp/create-a-code-security-configuration.json
timestamp=$(date +%s)

jq -n \
           --arg name "${org} the power security configuration $timestamp" \
           --arg description "${org} the power security configuration" \
           --arg advanced_security "enabled" \
           --arg dependabot_alerts "enabled" \
           --arg dependabot_security_updates "enabled" \
           --arg secret_scanning "enabled" \
           '{
             name: $name,
             description: $description,
             advanced_security: $advanced_security,
             dependabot_alerts: $dependabot_alerts,
             dependabot_security_updates: $dependabot_security_updates,
             secret_scanning: $secret_scanning
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations"  --data @${json_file}
