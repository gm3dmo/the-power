.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/billing?apiVersion=2022-11-28#get-all-cost-centers-for-an-enterprise
# GET /enterprises/{enterprise}/settings/billing/cost-centers


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    enterprise=$enterprise
  else
    enterprise=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/settings/billing/cost-centers" 

