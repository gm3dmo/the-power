.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/private-registries/organization-configurations?apiVersion=2022-11-28#create-a-private-registry-for-an-organization
# POST /orgs/{org}/private-registries


if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

json_file=tmp/create-a-private-registry-for-an-organization.json


jq -n \
           --arg registry_type "${registry_type}" \
           --arg username "${username}" \
           --argjson replaces_base "${replaces_base}" \
           --arg encrypted_value "${encrypted_value}" \
           --arg key_id "${key_id}" \
           --arg visibility "${visibility}" \
           --arg url "${registry_url}" \
           '{
             registry_type: $registry_type,
             url: $url,
             username: $username,
             replaces_base: $replaces_base,
             encrypted_value: $encrypted_value,
             key_id: $key_id,
             visibility: $visibility
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/private-registries"  --data @${json_file}

