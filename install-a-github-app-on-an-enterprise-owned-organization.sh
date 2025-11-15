.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/organization-installations?apiVersion=2022-11-28#install-a-github-app-on-an-enterprise-owned-organization
# POST /enterprises/{enterprise}/apps/organizations/{org}/installations


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi




repository_selection="all"

json_file=/tmp/install-a-github-app-on-an-enterprise-owned-organization.json
jq -n \
           --arg client_id "${ent_app_client_id}" \
           --arg repository_selection "${repository_selection}" \
           '{
             client_id : $client_id,
             repository_selection : $repository_selection,
           }' > ${json_file}


GITHUB_TOKEN=$(./ent-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/apps/organizations/${org}/installations"  --data @${json_file}

