.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-scanning/code-scanning?apiVersion=2022-11-28#list-code-scanning-alerts-for-an-enterprise
# GET /enterprises/{enterprise}/code-scanning/alerts


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
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/code-scanning/alerts" 
