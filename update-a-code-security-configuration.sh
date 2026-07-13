.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#update-a-code-security-configuration
# PATCH /orgs/{org}/code-security/configurations/{configuration_id}

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

json_file=tmp/update-a-code-security-configuration.json
timestamp=$(date +%s)

configuration_id=$(./get-code-security-configurations-for-an-organization.sh | jq '[.[].id] | max')

jq -n \
           --arg name "${org} the power security configuration updated $timestamp" \
           --arg description "${org} the power security configuration updated" \
           --arg secret_scanning "disabled" \
           --arg code_scanning_default_setup "enabled" \
           '{
             name: $name,
             description: $description,
             secret_scanning: $secret_scanning,
             code_scanning_default_setup: $code_scanning_default_setup
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/code-security/configurations/${configuration_id}"  --data @${json_file}
