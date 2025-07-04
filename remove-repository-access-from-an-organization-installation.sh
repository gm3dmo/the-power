.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/organization-installations?apiVersion=2022-11-28#remove-repository-access-from-an-organization-installation
# PATCH /enterprises/{enterprise}/apps/organizations/{org}/installations/{installation_id}/repositories/remove


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    installation_id=${ent_app_org_installation_id}
  else
    installation_id=$1
fi


json_file=tmp/remove-repository-access-from-an-organization-installation.json
jq -n \
           --arg repo "${repo}" \
           '{
             repositories : [ $repo ],
           }' > ${json_file}


GITHUB_TOKEN=$(./ent-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/apps/organizations/${org}/installations/${installation_id}/repositories/remove"  --data @${json_file}

