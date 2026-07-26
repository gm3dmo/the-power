.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-security/configurations?apiVersion=2026-03-10#update-a-custom-code-security-configuration-for-an-enterprise
# PATCH /enterprises/{enterprise}/code-security/configurations/{configuration_id}

if [ -z "$1" ]
  then
    enterprise=${enterprise}
  else
    enterprise=$1
fi

json_file=tmp/update-a-custom-code-security-configuration-for-an-enterprise.json
timestamp=$(date +%s)

configuration_id=$(./get-code-security-configurations-for-an-enterprise.sh | jq '[.[].id] | max')

jq -n \
           --arg name "${enterprise} the power security configuration updated $timestamp" \
           --arg secret_scanning "disabled" \
           --arg code_scanning_default_setup "enabled" \
           '{
             name: $name,
             secret_scanning: $secret_scanning,
             code_scanning_default_setup: $code_scanning_default_setup
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/code-security/configurations/${configuration_id}"  --data @${json_file}
