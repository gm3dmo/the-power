.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/custom-properties?apiVersion=2022-11-28#create-or-update-a-custom-property-for-an-organization
# PUT /orgs/{org}/properties/schema/{custom_property_name} 


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


json_file=tmp/create-or-update-a-custom-property-for-an-organization.json

custom_property_name="the-power-org-property"


jq -n \
           --arg name "${repo}" \
           '{
             "value_type":"single_select","required":true,"default_value":"production","description":"Prod or dev environment","allowed_values":["production","development", "the-power"]
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/properties/schema/${custom_property_name}"  --data @${json_file}
