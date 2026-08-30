.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#create-a-code-security-configuration-for-an-enterprise
# POST /enterprises/{enterprise}/code-security/configurations

if [ -z "$1" ]
  then
    enterprise=${enterprise}
  else
    enterprise=$1
fi

json_file=tmp/create-a-code-security-configuration-for-an-enterprise.json
timestamp=$(date +%s)

jq -n \
           --arg name "${enterprise} the power security configuration $timestamp" \
           --arg description "${enterprise} the power security configuration" \
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
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/code-security/configurations"  --data @${json_file}
