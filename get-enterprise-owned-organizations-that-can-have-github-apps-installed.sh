.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/organization-installations?apiVersion=2022-11-28#get-enterprise-owned-organizations-that-can-have-github-apps-installed
# GET /enterprises/{enterprise}/apps/installable_organizations


if [ -z "$1" ]
  then
    enterprise=$enterprise
  else
    enterprise=$1
fi


GITHUB_TOKEN=$(./ent-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/apps/installable_organizations"

