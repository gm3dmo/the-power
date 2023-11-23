.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.10/rest/orgs/orgs?apiVersion=2022-11-28#enable-or-disable-a-security-feature-for-an-organization
# POST /orgs/{org}/{security_product}/{enablement}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


enablement="enable_all"
security_product="dependabot_alerts"

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/${security_product}/${enablement}"  --data @${json_file}

