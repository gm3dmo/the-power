.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#create-an-oidc-custom-property-inclusion-for-an-organization
# POST /orgs/{org}/actions/oidc/customization/properties/repo

# You must authenticate using an access token with the admin:org scope to use this endpoint.

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

custom_property_name=${2:?You must pass a custom_property_name as the second argument}

json_file=tmp/create-an-oidc-custom-property-inclusion-for-an-organization.json
jq -n \
       --arg custom_property_name "${custom_property_name}" \
           '{
             custom_property_name: $custom_property_name
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/oidc/customization/properties/repo" -d @${json_file}
